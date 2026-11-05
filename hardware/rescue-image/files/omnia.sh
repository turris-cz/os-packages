#!/bin/sh

. /lib/board_helpers.sh

# Busybox has no awk here
find_mtd_index() {
    sed -n 's|^mtd\([0-9]*\):.*"'"$1"'"$|\1|p' /proc/mtd | head -n 1
}

# leds-turris-omnia has one node per LED and none for all of them
LEDS="power lan-0 lan-1 lan-2 lan-3 lan-4 wan wlan-1 wlan-2 wlan-3 indicator-1 indicator-2"

# Set the colour of all LEDs, "R G B"
leds_color() {
    local led
    for led in $LEDS; do
        [ -e /sys/class/leds/rgb\:$led/multi_intensity ] || continue
        echo "$1" > /sys/class/leds/rgb\:$led/multi_intensity
    done
}

leds_trigger() {
    local led
    for led in $LEDS; do
        [ -e /sys/class/leds/rgb\:$led/trigger ] || continue
        echo "$1" > /sys/class/leds/rgb\:$led/trigger
    done
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
    elif grep -q 'U-Boot 2015.10-rc2' /dev/mtd0; then
        echo "/dev/mtd0 0xc0000 0x10000 0x40000" > /etc/fw_env.config
    else
        echo '/dev/mtd0 0xF0000 0x10000 0x10000' > /etc/fw_env.config
    fi
    TARGET_DRIVE="/dev/mmcblk0"
    PART_NO="1"
    TARGET_PART="${TARGET_DRIVE}p${PART_NO}"
    BRIGHT="`cat /sys/class/leds/rgb\:power/device/brightness 2> /dev/null`"
    # The LEDs show the mode. The button steps 0 to 100 and that would be put
    # back, so on a dark board each press would change the mode unseen.
    if [ "$BRIGHT" = 0 ]; then
        echo 100 > /sys/class/leds/rgb\:power/device/brightness && BRIGHT=100
    fi
    WAN_IF="eth2"
    DELAY=40
    RESCUE_IF="`ip a s | sed -n 's|^[0-9]*:[[:blank:]]*\(lan4\)@.*|\1|p'`"
    RESCUE_IF_UP="`ip a s | sed -n 's|^[0-9]*:[[:blank:]]*\(lan4\)@\([^:]*\):.*|\2|p'`"
    leds_color '0 255 0'
    leds_trigger default-on
    enable_btrfs
    generic_post_init
}

# The button changes the global brightness. Use a change of it to select the
# next mode and put the brightness back.
check_for_mode_change() {
    local cur="`cat /sys/class/leds/rgb\:power/device/brightness 2> /dev/null`"
    [ -n "$cur" ] && [ -n "$BRIGHT" ] || return 1
    if [ "$cur" -ne "$BRIGHT" ]; then
        # When it can't be put back, keep the new value, or every next look
        # would be taken for another press
        echo "$BRIGHT" > /sys/class/leds/rgb\:power/device/brightness || BRIGHT="$cur"
        return 0
    fi
    return 1
}

# Show the mode as the number of lit LEDs, starting with power
display_mode() {
    local led n=0
    leds_color '255 64 0'
    leds_trigger none
    for led in $LEDS; do
        n="$(expr $n + 1)"
        [ -e /sys/class/leds/rgb\:$led/trigger ] || continue
        if [ "$n" -le "$MODE" ]; then
            echo default-on > /sys/class/leds/rgb\:$led/trigger
        else
            echo 0 > /sys/class/leds/rgb\:$led/brightness
        fi
    done
}

busy() {
    leds_color '255 0 0'
}

die() {
    predie "$1" "$2"
    leds_color '0 0 255'
    leds_trigger timer
    while true; do
        sleep 1
    done
}

