#!/bin/sh

# Generic helper functions
reset_uenv() {
    local bootcmd="env default -f -a;"

    # Carry all important variables across resets, but remove empty variables
    # to help people who just empty them instead of deleting

    # We want to update root_uuid if there was reflash
    if [ -n "$(fw_printenv -n root_uuid 2> /dev/null)" ]; then
        bootcmd="$bootcmd setenv root_uuid $(blkid "$TARGET_PART" | sed 's|.*UUID="\([^"]*\)".*|\1|');"
    fi

    # Rest of variable we will just carry over
    #
    # contract - what contracts is router under
    # rescue_mode - default rescue mode if not specified - differs between MOX and Shield
    # boot_targets - to allow prioritize booting from SSD
    for var in contract rescue_mode boot_targets; do
        local value="$(fw_printenv -n $var 2> /dev/null)"
        if [ -n "$value" ]; then
            bootcmd="$bootcmd setenv $var '$value';"
        fi
    done
    fw_setenv bootcmd "$bootcmd saveenv; reset"
}

enable_btrfs() {
    MODE1_NEXT=2
    mkdir -p /etc/schnapps
    echo "ROOT_DEV='${TARGET_PART}'" > /etc/schnapps/config
}

disable_btrfs() {
    rm -rf /etc/schnapps
    MODE1_NEXT=3
}

uuid2part() {
    local uuid="$1"
    local retry=5
    local part=
    # Wait for specified device a little
    while [ "$retry" -gt 0 ] && [ -z "$part" ]; do
        part="$(blkid | sed -n 's|^/dev/\([^:]*\):.*UUID="'"$uuid"'".*|\1|p' | head -n 1)"
        sleep 1
        retry="$(expr "$retry" - 1)"
    done
    echo "$part"
}

override_root() {
    if [ -n "$(fw_printenv root_uuid 2> /dev/null)" ]; then
        UUID="$(fw_printenv root_uuid | sed 's|root_uuid=||')"
        NEW_TARGET_PART="$(uuid2part "$UUID")"
        if [ "$NEW_TARGET_PART" ] && [ -d "/sys/class/block/$NEW_TARGET_PART" ]; then
            NEW_TARGET_DRIVE="$(ls -d /sys/class/block/*/"$NEW_TARGET_PART" | sed 's|/.*/\([^/]*\)/'"$NEW_TARGET_PART"'|\1|')"
            if [ -d "/sys/class/block/$NEW_TARGET_DRIVE" ]; then
                TARGET_PART="/dev/$NEW_TARGET_PART"
                PART_NO="$(echo "$NEW_TARGET_PART" | sed -n 's|.*[^0-9]\([0-9]\+\)$|\1|p')"
                TARGET_DRIVE="/dev/$NEW_TARGET_DRIVE"
                enable_btrfs # re-setup btrfs now with new device
            fi
        fi
        echo "Newly selected root device is $TARGET_PART"
    fi
}

wait_for_mode_change() {
    echo "Now is your chance to change a mode from $MODE to something else, press the button to do so"
    waited=0
    display_mode
    [ "$DELAY" -gt 0 ] || return
    half_delay="$(expr "$DELAY" / 2)"
    echo "Waiting for $(expr $DELAY / 10)s ..."
    while [ "$waited" -le "$DELAY" ]; do
        if check_for_mode_change; then
            waited=-9
            next_mode
            echo "Mode changed to $MODE"
            eval echo '$MODE'"$MODE"
            display_mode
        elif [ "$waited" -eq "$half_delay" ]; then
            display_mode
        fi
        [ "$(expr $waited % 10)" -ne 0 ] || echo "$(expr \( "$DELAY" - "$waited" \) / 10)s left"
        sleep 0.1
        waited="$(expr $waited + 1)"
    done
}

DHCP_OPTS="-qfn"
download_medkit() {
    tries=3
    i=0
    local time_to_end=""
    for wan_if in $WAN_IF; do
        echo "Trying to get online using $wan_if"
        ip link set up dev "$wan_if"
        time_to_end=""
        while ! udhcpc -i "$wan_if" $DHCP_OPTS && [ -z "$time_to_end" ]; do
            echo "No DHCP :-("
            sleep 2
            i="$(expr "$i" + 1)"
            [ "$i" -lt "$tries" ] || time_to_end="yes"
        done
        if [ -n "$time_to_end" ]; then
            echo "Can't get IP"
            continue
        fi
        echo "Got IPv4!"
        ip addr show
        ip route show
        grep -q nameserver /etc/resolv.conf || echo nameserver 193.17.47.1 > /etc/resolv.conf
        mkdir -p /mnt/src
        # Download medkit and signature
        for ext in tar.gz tar.gz.sig; do
            local i=0
            # We are checking signature, so we don't care about https
            while ! wget -O /mnt/src/medkit.$ext http://repo.turris.cz/hbs/medkit/${BOARD}-medkit${MDKT_VARIANT}-latest.$ext; do
                echo "Can't download $BOARD-medkit-latest.$ext :-("
                sleep 2
                i="$(expr "$i" + 1)"
                [ "$i" -lt "$tries" ] || die 2 "Can't get $BOARD-medkit-latest.$ext"
            done
            i=0
            if [ -n "$NOR_UPDATE" ]; then
                while ! rescue_wget -O /mnt/src/nor.$ext http://repo.turris.cz/hbs/medkit/${BOARD}-nor-latest.$ext; do
                    echo "Can't download $BOARD-nor-latest.$ext :-("
                    sleep 2
                    i="$(expr "$i" + 1)"
                    [ "$i" -lt "$tries" ] || die 2 "Can't get $BOARD-nor-latest.$ext"
                done
            fi
        done
        usign -V -m /mnt/src/medkit.tar.gz -P /etc/opkg/keys || die 2 "Can't validate medkit signature"
        if [ -n "$NOR_UPDATE" ]; then
            usign -V -m /mnt/src/nor.tar.gz -P /etc/opkg/keys || die 2 "Can't validate nor signature"
        fi
        echo "medkit.tar.gz" > /tmp/medkit-file
        break
    done
    [ -z "$time_to_end" ] || die 1 "No internet :-("
}

# Checks /mnt/src/$1 against the hash in its checksum file $2 with the tool $3.
# Only the hash counts, so "hash  name", "hash *name" and a bare hash all work.
check_checksum() {
    local want got
    want="$(sed -n '1{s/^[[:space:]]*//;s/[[:space:]].*//;y/ABCDEF/abcdef/;p;}' "$2")"
    got="$("$3" "/mnt/src/$1" | sed 's/[[:space:]].*//')"
    [ -n "$want" ] && [ "$want" = "$got" ]
}

# Checks the optional .md5, .sha256 and .sig of a file in /mnt/src
check_medkit_file() {
    local f="$1"
    if [ -f "/mnt/src/$f".md5 ] && ! check_checksum "$f" "/mnt/src/$f".md5 md5sum; then
        echo "Wrong md5 sum for $f"
        return 1
    fi
    if [ -f "/mnt/src/$f".sha256 ] && ! check_checksum "$f" "/mnt/src/$f".sha256 sha256sum; then
        echo "Wrong sha256 sum for $f"
        return 1
    fi
    if [ -f "/mnt/src/$f".sig ]; then
        usign -V -m "/mnt/src/$f" -P /etc/opkg/keys || return 1
    fi
    echo "Nothing wrong with it"
}

# Adds the valid files that match patterns $3 on the drive $1, mounted at
# /mnt/src, to /tmp/$2-list as "name drive" lines. A file that fails its
# checks creates /tmp/$2-rejected.
list_valid_files() {
    local d="$1" kind="$2" f
    # read keeps each name as is, a for loop over $(ls) would glob it
    (cd /mnt/src && ls -1 $3 2> /dev/null) | while read -r f; do
        case "$f" in
            *' '*|*'	'*) continue ;;
        esac
        [ -f "/mnt/src/$f" ] || continue
        echo "Found $f on device $d"
        if check_medkit_file "$f"; then
            echo "$f $d" >> /tmp/"$kind"-list
        else
            : > /tmp/"$kind"-rejected
        fi
    done
}

# Picks the OpenWrt disk image of the board, if exactly one valid image is on
# the drives. A second image stops the rescue instead of guessing.
find_openwrt_image() {
    local name drive
    [ -n "$OPENWRT_IMAGES" ] || return 0
    for d in /dev/mmcblk*p* /dev/sd*; do
        [ -e "$d" ] || continue
        mount "$d" /mnt/src || continue
        list_valid_files "$d" image "$OPENWRT_IMAGES"
        umount -fl /mnt/src
    done
    [ -s /tmp/image-list ] || return 0
    [ "$(wc -l < /tmp/image-list)" -eq 1 ] || die 2 "More than one OpenWrt image found, keep only one"
    read -r name drive < /tmp/image-list
    echo "No medkit found, using OpenWrt image $name from $drive"
    echo "$name" > /tmp/medkit-file
    echo "$drive" > /tmp/medkit-drive
}

# Takes as an argument number of retries
find_medkit() {
    local name drive
    echo "Searching for medkit"
    i=0
    retries="$1"
    mkdir -p /mnt/src
    rm -f /tmp/medkit-drive /tmp/medkit-file /tmp/medkit-list /tmp/medkit-sorted /tmp/medkit-rejected /tmp/image-list
    # Till we run out of retries or find the image
    while [ "$i" -lt "$retries" ] && [ \! -s /tmp/medkit-list ]; do
        sleep 1
        i="$(expr "$i" + 1)"
        # Search all block devices
        for d in /dev/mmcblk*p* /dev/sd*; do
            [ -e "$d" ] || continue
            mount "$d" /mnt/src || continue
            echo "Trying device $d"
            list_valid_files "$d" medkit "$BOARD-medkit${MDKT_VARIANT}*.tar.gz medkit-$BOARD${MDKT_VARIANT}.tar.gz medkit-$BOARD${MDKT_VARIANT}-*.tar.gz"
            umount -fl /mnt/src
        done
    done
    if [ -s /tmp/medkit-list ]; then
        # Each pass searches all drives, the passes only wait for slow ones.
        # The greatest name is the newest medkit. read takes the name as is,
        # without the glob expansion of an unquoted $(...).
        sort -r /tmp/medkit-list > /tmp/medkit-sorted
        read -r name drive < /tmp/medkit-sorted
        echo "Using medkit $name from $drive"
        echo "$name" > /tmp/medkit-file
        echo "$drive" > /tmp/medkit-drive
    elif [ \! -f /tmp/medkit-rejected ]; then
        # An OpenWrt image only counts if there is no medkit, not even a broken one
        find_openwrt_image
    fi
    if [ \! -f /tmp/medkit-file ] && [ -f /mnt/src/medkit.tar.gz ]; then
        echo "No medkit on any drive found, using built-in"
        echo "medkit.tar.gz" > /tmp/medkit-file 
    fi
    [ -f /tmp/medkit-file ] || die 2 "No valid medkit found!"
}

# Takes as an argument directory where to mount target drive
format_and_mount_target() {
    trg_mnt_pth="$1"
    if [ -n "$HAVE_BTRFS" ]; then
        if [ -n "$REPARTITION" ]; then
            echo "Repartitioning the drive..."
            fdisk "$TARGET_DRIVE" >> /tmp/debug.txt 2>&1 <<EOF
o
n
p
$PART_NO


p
w
EOF
            [ $? -eq 0 ] || die 3 "Partitioning drive failed"
            mdev -s
        fi
        fdisk -l "$TARGET_DRIVE" >> /tmp/debug.txt
        echo "Formatting the drive..."
        mkfs.btrfs -f "$TARGET_PART" >> /tmp/debug.txt 2>&1 || die 3 "Can't format the partition"
        mkdir -p "$trg_mnt_pth"
        mount "$TARGET_PART" "$trg_mnt_pth" || die 3 "Can't mount the partition"
        btrfs subvolume create "$trg_mnt_pth"/@ >> /tmp/debug.txt 2>&1 || die 3 "Can't create a subvolume"
        ln -s @/boot/boot.scr "$trg_mnt_pth"/boot.scr
        mkdir -p "$trg_mnt_pth"/@/etc/schnapps/
        echo "ROOT_DEV='${TARGET_PART}'" >> "$trg_mnt_pth"/@/etc/schnapps/config
        umount "$trg_mnt_pth"
        mount "$TARGET_PART" -o subvol=@ "$trg_mnt_pth"
    fi
}

create_factory() {
    echo "Backing up the current image as new factory"
    if [ -n "$HAVE_BTRFS" ]; then
        mkdir -p /mnt/tmp
        mount "$TARGET_PART" /mnt/tmp
        btrfs subvolume snapshot /mnt/tmp/@ /mnt/tmp/@factory
        sync
        umount -fl /mnt/tmp
    fi
}

# Adjust RTC if image is from the future
check_clock() {
    hwclock -s
    current_date="$(date '+%s')"
    image_date="$(date '+%s' -r "$1")"
    if [ "$current_date" -lt "$image_date" ]; then
        echo "Adjusting hardware clock"
        date "@$image_date"
        hwclock -w
    fi
}

# Writes a whole disk image, such as an OpenWrt image, to the target drive
flash_image() {
    local img="/mnt/src/$(cat /tmp/medkit-file)" try=0
    [ -b "$TARGET_DRIVE" ] || die 3 "No target drive $TARGET_DRIVE"
    # Test the whole image first, so a broken one leaves the drive as it is
    echo "Checking $(cat /tmp/medkit-file)"
    gzip -t "$img" >> /tmp/debug.txt 2>&1 || die 2 "The image is damaged"
    echo "Writing it to $TARGET_DRIVE"
    ( set -o pipefail; gzip -dc "$img" | dd of="$TARGET_DRIVE" bs=4M conv=fsync ) >> /tmp/debug.txt 2>&1 \
        || die 2 "Flashing failed!!!"
    sync
    # A lazily unmounted partition can keep the drive busy for a moment
    until blockdev --rereadpt "$TARGET_DRIVE" >> /tmp/debug.txt 2>&1; do
        try="$(expr "$try" + 1)"
        if [ "$try" -ge 3 ]; then
            echo "Can't reread the partition table, the reboot will do it"
            break
        fi
        sleep 1
    done
    mdev -s
    echo "Image should be ready"
    case "$(cat /tmp/medkit-file)" in
        *-ext4-*) echo "Note: factory reset works only with a squashfs root, not with this ext4 image" ;;
    esac
}

root_is_btrfs() {
    blkid "$TARGET_PART" | grep -q 'TYPE="btrfs"'
}

# Prints the second partition of the target drive, the OpenWrt root
openwrt_root_part() {
    case "$TARGET_DRIVE" in
        *[0-9]) echo "${TARGET_DRIVE}p2" ;;
        *) echo "${TARGET_DRIVE}2" ;;
    esac
}

# Prints the little endian number made of the bytes given as arguments
le() {
    local v=0 s=0 b
    for b in "$@"; do
        v=$(( v + (b << s) ))
        s=$(( s + 8 ))
    done
    echo "$v"
}

# Prints where the OpenWrt overlay starts, in 64 KiB blocks of the root
# partition. fstools puts it after the squashfs root, aligned to 64 KiB.
openwrt_overlay_block() {
    local part="$(openwrt_root_part)" size bsize blog used idt inode dirt block
    [ -b "$part" ] || return 1
    [ "$(dd if="$part" bs=4 count=1 2> /dev/null)" = hsqs ] || return 1
    # Without the partition size, the bounds check below can't work
    size="$(blockdev --getsize64 "$part")" || return 1
    case "$size" in
        ''|*[!0-9]*) return 1 ;;
    esac
    # The 96 bytes of the squashfs 4.0 superblock
    set -- $(hexdump -n 96 -v -e '1/1 "%u "' "$part")
    [ "$#" -eq 96 ] || return 1
    bsize="$(le ${13} ${14} ${15} ${16})"
    blog="$(le ${23} ${24})"
    used="$(le ${41} ${42} ${43} ${44} ${45} ${46} ${47} ${48})"
    idt="$(le ${49} ${50} ${51} ${52} ${53} ${54} ${55} ${56})"
    inode="$(le ${65} ${66} ${67} ${68} ${69} ${70} ${71} ${72})"
    dirt="$(le ${73} ${74} ${75} ${76} ${77} ${78} ${79} ${80})"
    block=$(( (used + 65535) / 65536 ))
    # Version 4, a block size of 4 KiB to 1 MiB that matches block_log, and
    # the tables in their order inside bytes_used. The wipe of 16 blocks must
    # stay inside the partition.
    if [ "$(le ${29} ${30})" -ne 4 ] || [ "$blog" -lt 12 ] || [ "$blog" -gt 20 ] ||
        [ "$bsize" -ne $(( 1 << blog )) ] || [ "$inode" -lt 96 ] ||
        [ "$inode" -ge "$dirt" ] || [ "$dirt" -ge "$used" ] || [ "$idt" -ge "$used" ] ||
        [ "$(( (block + 16) * 65536 ))" -gt "$size" ]; then
        echo "The squashfs superblock on $part looks damaged" >&2
        return 1
    fi
    echo "$block"
}

reflash() {
    if [ -f /tmp/medkit-drive ]; then
        if expr "$(cat /tmp/medkit-drive)" : "${TARGET_DRIVE}.*" > /dev/null; then
            echo "Copying medkit to RAM"
            mkdir -p /mnt/tmp
            mount "$(cat /tmp/medkit-drive)" /mnt/tmp || die 2 "Can't mount $(cat /tmp/medkit-drive)"
            cp /mnt/tmp/"$(cat /tmp/medkit-file)" /mnt/src || die 2 "Can't copy the medkit to RAM"
            local extra_file="/mnt/tmp/$(sed -n 's|\.tar\.gz$|-extra.tar.gz|p' /tmp/medkit-file)"
            if [ -f "$extra_file" ]; then
                cp "$extra_file" /mnt/src
            fi
            umount -fl /mnt/tmp
            rm -f /tmp/medkit-drive
        else
            mount "$(cat /tmp/medkit-drive)" /mnt/src || die 2 "Can't mount $(cat /tmp/medkit-drive)"
        fi
    fi
    # Nothing on the target is changed yet, so stop here if the file is gone
    [ -f /mnt/src/"$(cat /tmp/medkit-file)" ] || die 2 "$(cat /tmp/medkit-file) is not there any more"
    case "$(cat /tmp/medkit-file)" in
        *.img.gz)
            flash_image
            return
            ;;
    esac
    format_and_mount_target /mnt/trg
    echo "Unpacking rootfs to the target directory"
    mount >> /tmp/debug.txt
    tar -C /mnt/trg -xzf /mnt/src/"$(cat /tmp/medkit-file)" >> /tmp/debug.txt || die 2 "Flashing failed!!!"
    local extra_file="/mnt/src/$(sed 's|\.tar\.gz$|-extra.tar.gz|' /tmp/medkit-file)"
    if [ -f "$extra_file" ]; then
        tar -C /mnt/trg -xzf "$extra_file" >> /tmp/debug.txt || die 2 "Flashing failed!!!"
    fi
    echo "Rootfs should be ready"
    check_clock /mnt/trg/etc/shadow
    sync
    umount -fl /mnt/trg
    create_factory
    if [ -n "$NOR_UPDATE" ] && [ -f /mnt/src/nor.tgz ]; then
        mkdir -p /mnt/src/nor
        tar -C /mnt/src/nor -xzvf /mnt/src/nor.tgz || die 2 "Unpacking NOR failed!!!"
        cd /mnt/src/nor
        for img in *.img; do
            mtd="$(grep "$(basename "$img" .img)\"" /proc/mtd | sed 's|^\([^[:blank:]]*\):\ \([^[:blank:]]*\)\ \([^[:blank:]]*\)\ .*|/dev/\1|' | head -n1)"
            [ -z "$mtd" ] || mtd write $img $mtd
        done
    fi
}

reboot() {
    echo "Rebooting!"
    sync
    echo "Debug info:"
    cat /tmp/debug.txt 2> /dev/null
    rm -f "$(which watchdog)"
    killall watchdog 2> /dev/null
    /sbin/reboot -f
    echo s > /proc/sysrq-trigger
    echo b > /proc/sysrq-trigger
    # Should be enough to let watchdog kill us
    sleep 999999
}

# Simple udev
simple_udev() {
    while true; do
        mdev -s
        if [ -e /dev/watchdog0 ] && ! pidof watchdog > /dev/null; then
            watchdog -t 10 -T 60 /dev/watchdog0
        fi
        sleep 1
    done
}

# All the stuff proper init system should do and nothing more
init() {
    echo "Initializing the system"
    mount -t sysfs none /sys
    mount -t proc none /proc
    mkdir /dev/pts
    mount -t devpts devpts /dev/pts

    board_pre_init

    ip addr add 127.0.0.1/8 dev lo
    ip link set up dev lo

    depmod
    cat /etc/modules-boot.d/* /etc/modules.d/* | while read mod; do
        [ -z "$mod" ] || modprobe $mod
    done

    simple_udev &

    generic_pre_init
    board_init
    generic_post_init
}

next_mode() {
    # Next mode in line is in MODE[1-9]_NEXT variable, so some of them can be skipped or rearranged
    eval NEXT='$MODE'"$MODE"'_NEXT'
    if [ -n "$NEXT" ]; then
        MODE="$NEXT"
    else
        # Default next mode is one number higher if not set
        MODE="$(expr "$MODE" + 1 )"
    fi
    if [ "$MODE" -gt "$MAX_MODE" ]; then
        MODE=1
    fi
}

prev_mode() {
    echo "Decreasing mode from $MODE"
    MODE="$(expr "$MODE" - 1 )"
    echo "We are at $MODE"
    if [ "$MODE" -lt 1 ]; then
        MODE="$MAX_MODE"
    fi
    echo "After corrections: $MODE"
}


fetch_cmd_mode() {
    local cmd_mode=""
    cmd_mode="$(sed -n 's|.*rescue_mode=\([0-9]\+\).*|\1|p' /proc/cmdline)"
    [ -n "$cmd_mode" ] || cmd_mode="$(fw_printenv -n rescue_mode 2> /dev/null)"
    echo "Rescue mode $cmd_mode + 1 selected on cmdline"
    if [ -n "$cmd_mode" ]; then
        MODE="$(expr "$cmd_mode" + 1)"
        if [ "$MODE" -gt 7 ] || [ "$MODE" -le 0 ] || [ -z "$MODE" ]; then
            MODE=1
        fi
    fi
    FORCE_MODE="$(sed -n 's|.*force_mode=\([0-9]\+\).*|\1|p' /proc/cmdline)"
    NOR_UPDATE="$(sed -n 's|.*nor_update.*|yes|p' /proc/cmdline)"
    [ -z "$FORCE_MODE" ] || MODE="$FORCE_MODE"
}

# Various modes

MODE1="Reset"
mode_1() {
    reboot
}

# Rollback
MODE2="Btrfs rollback"
mode_2() {
    echo "Running btrfs rollback"
    root_is_btrfs || die 3 "Rollback needs a btrfs root"
    schnapps rollback || die 3 "Rollback failed"
}

# Factory reset
MODE3="Factory reset"
mode_3() {
    local block
    echo "Running factory reset"
    if root_is_btrfs; then
        reset_uenv || die 3 "Can't reset the U-Boot environment"
        schnapps rollback factory || die 3 "Factory reset failed"
    elif block="$(openwrt_overlay_block)"; then
        # OpenWrt formats a wiped overlay on the next boot, as after a flash.
        # Like its own factory reset, this keeps the U-Boot environment.
        echo "Wiping the OpenWrt overlay"
        dd if=/dev/zero of="$(openwrt_root_part)" bs=64k seek="$block" count=16 conv=fsync >> /tmp/debug.txt 2>&1 \
            || die 3 "Can't wipe the OpenWrt overlay"
    else
        die 3 "Factory reset needs a btrfs root or OpenWrt on squashfs"
    fi
}

# Reflash from USB
MODE4="USB flash"
mode_4() {
    echo "Running USB flash"
    find_medkit 5
    reflash
    reset_uenv
}

# Open open ssh console
MODE5="Unsecure SSH on 192.168.1.1"
mode_5() {
    echo "Running unsecure ssh"
    ip link add name br_lan type bridge
    ip link set br_lan up
    for i in $RESCUE_IF $RESCUE_IF_UP; do
        ip link set $i up
    done
    for i in $RESCUE_IF; do
        ip link set $i master br_lan
        ip link set $i up
    done
    ip link set br_lan up
    ip addr add 192.168.1.1/24 dev br_lan
    rm -f /etc/dropbear/*
    dropbear -R -B -E
    success
    setsid cttyhack sh
    reboot
}

# Flash directly from the internet
MODE6="Flash from the Cloud :-)"
mode_6() {
    echo "Flashing from the Cloud :-)"
    download_medkit
    reflash
    reset_uenv
}

MODE7="Serial console"
MODE7_NEXT=1
mode_7() {
    echo "Running shell"
    success
    setsid cttyhack sh
    reboot
}
MAX_MODE=7

