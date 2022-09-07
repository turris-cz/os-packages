#!/bin/sh

. /lib/board_helpers.sh

find_mtd_index() {
    local PART="$(grep "\"$1\"" /proc/mtd | awk -F: '{print $1}')"
    local INDEX="${PART##mtd}"

    echo ${INDEX}
}

board_init() {
    local idx

    generic_pre_init
    # Default mode on Omnia is serial
    MODE=7
    mkdir -p /etc
    idx="$(find_mtd_index u-boot-env)"
    if [ -n "$idx" ]; then
        echo "/dev/mtd${idx} 0x0 0x10000 0x10000" > /etc/fw_env.config
    else
        echo '/dev/mtd0 0xF0000 0x10000 0x10000' > /etc/fw_env.config
    fi
    TARGET_DRIVE="/dev/mmcblk0"
    PART_NO="1"
    TARGET_PART="${TARGET_DRIVE}p${PART_NO}"
    BRIGHT="`cat /sys/class/leds/rgb\:all/device/brightness`"
    WAN_IF="eth2"
    DELAY=40
    RESCUE_IF="`ip a s | sed -n 's|^[0-9]*:[[:blank:]]*\(lan-4\)@.*|\1|p'`"
    RESCUE_IF_UP="`ip a s | sed -n 's|^[0-9]*:[[:blank:]]*\(lan-4\)@\([^:]*\):.*|\2|p'`"
    echo '0 255 0' >  /sys/class/leds/rgb\:all/multi_intensity
    echo default-on > /sys/class/leds/rgb\:all/trigger
    enable_btrfs
    generic_post_init
}

check_for_mode_change() {
    if [ "`cat /sys/class/leds/rgb\:all/device/brightness`" -ne "$BRIGHT" ]; then
        echo "$BRIGHT" > /sys/class/leds/rgb\:all/device/brightness
        return 0
    fi
    return 1
}

display_mode() {
    MODE_TG=default-on
    echo '255 64 0' >  /sys/class/leds/rgb\:all/multi_intensity
    for i in /sys/class/leds/rgb*; do
        echo none > "$i"/trigger
    done
    echo "$MODE_TG" > /sys/class/leds/rgb\:power/trigger
    if [ "$MODE" -gt 1 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:lan-0/trigger
    fi
    if [ "$MODE" -gt 2 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:lan-1/trigger
    fi
    if [ "$MODE" -gt 3 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:lan-2/trigger
    fi
    if [ "$MODE" -gt 4 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:lan-3/trigger
    fi
    if [ "$MODE" -gt 5 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:lan-4/trigger
    fi
    if [ "$MODE" -gt 6 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:wan/trigger
    fi
    if [ "$MODE" -gt 7 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:wlan-1/trigger
    fi
    if [ "$MODE" -gt 8 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:wlan-2/trigger
    fi
    if [ "$MODE" -gt 9 ]; then
        echo "$MODE_TG" > /sys/class/leds/rgb\:wlan-3/trigger
    fi
}

busy() {
    echo '255 0 0' >  /sys/class/leds/rgb\:all/multi_intensity
}

die() {
    predie "$1" "$2"
    echo '0 0 255' >  /sys/class/leds/rgb\:all/multi_intensity
    echo timer > /sys/class/leds/rgb\:all/trigger
    while true; do
        sleep 1
    done
}

