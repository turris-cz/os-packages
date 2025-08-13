#!/bin/sh

. /lib/board_helpers.sh

board_init() {
    generic_pre_init
    # Default mode on Omnia NG is serial
    MODE=1
    mkdir -p /etc
    echo "/dev/mtd16 0x0 0x0 0x10000" > /etc/fw_env.config
    TARGET_DRIVE="/dev/mmcblk0"
    PART_NO="1"
    TARGET_PART="${TARGET_DRIVE}p${PART_NO}"
    BRIGHT="`cat /sys/class/leds/omnia-led\:all/device/global_brightness`"
    WAN_IF="eth0 eth4"
    MAX_MODE=6
    MODE6_NEXT=1
    DELAY=0
    RESCUE_IF="`ip a s | sed -n 's|^[0-9]*:[[:blank:]]*\(eth3\)@.*|\1|p'`"
    RESCUE_IF_UP="`ip a s | sed -n 's|^[0-9]*:[[:blank:]]*\(eth3\)@\([^:]*\):.*|\2|p'`"
    echo '0 255 0' >  /sys/class/leds/rgb\:indicator/multi_intensity
    echo default-on > /sys/class/leds/rgb\:indicator/trigger
    SELECTED_MODE=""
    enable_btrfs
    generic_post_init
}

check_for_mode_change() { return 1; }

reset_uenv() {
    :;
}

display_mode() {
    [ -z "$SELECTED_MODE" ] || return
    echo '255 64 0' > /sys/class/leds/rgb\:indicator/multi_intensity
    local key=""
    local key_pressed=""
    while [ "$key" != "1c" ]; do
        [ -e /dev/input/event0 ] || {
            sleep 1
            continue
        }
        dd if=/usr/share/rescue/$MODE.rgb of=/dev/fb0 > /dev/null 2>&1
        [ -n "$key" ] || {
            sleep 1
            MODE=1
            dd if=/usr/share/rescue/1.rgb of=/dev/fb0 > /dev/null 2>&1
        }
        echo "Current mode is $MODE"
        key="$(head -c 20 /dev/input/event0 | tail -c 2 | hexdump -e '"%02x"')"
        if [ -z "$key_pressed" ]; then
            echo "Key $key pressed"
        else
            echo "Key $key released"
        fi
        if [ "$key" = "6c" ]; then
            if [ -n "$key_pressed" ]; then
                key_pressed=""
            else
                next_mode
                key_pressed="yes"
            fi
        elif [ "$key" = "67" ]; then
            if [ -n "$key_pressed" ]; then
                key_pressed=""
            else
                prev_mode
                key_pressed="yes"
            fi
        fi
    done
    SELECTED_MODE="$MODE"
}

busy() {
    echo '255 0 0' >  /sys/class/leds/rgb\:indicator/multi_intensity
    frame=0
    while true; do
        dd if=/usr/share/rescue/wip-$frame.rgb of=/dev/fb0 > /dev/null 2>&1
        sleep 0.15
        frame=$((frame + 1))
        frame=$((frame % 6))
    done &
}

die() {
    predie "$1" "$2"
    echo '0 0 255' >  /sys/class/leds/rgb\:indicator/multi_intensity
    echo timer > /sys/class/leds/rgb\:indicator/trigger
    while true; do
        sleep 1
    done
}

