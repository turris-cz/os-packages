#!/bin/sh

board_preinit() {
    {
    while [ ! -e /dev/fb0 ]; do
        sleep 0.2;
    done
    sleep 0.2
    echo 0 > /sys/class/graphics/fb0/blank
    dd if=/usr/share/rescue/rescue.rgb of=/dev/fb0 > /dev/null 2>&1
    } &
    :
}

success() {
    echo '255 255 0' > /sys/class/leds/rgb\:indicator/multi_intensity
    echo 1 > /busy_stop
    dd if=/usr/share/rescue/ok.rgb of=/dev/fb0 > /dev/null 2>&1
    grep -v 'dont_reboot' /proc/cmdline > /dev/null || sleep 99999
    sleep 2
}

board_init() {
    # Default mode on Omnia NG is serial
    MODE=1
    mkdir -p /etc
    grep APPSBLENV /proc/mtd | sed 's|^\([^[:blank:]]*\):\ \([^[:blank:]]*\)\ \([^[:blank:]]*\)\ .*|/dev/\1 0x0 \2 \3|' > /etc/fw_env.config
    TARGET_DRIVE="/dev/mmcblk0"
    PART_NO="1"
    TARGET_PART="${TARGET_DRIVE}p${PART_NO}"
    WAN_IF="eth0 eth4"
    MAX_MODE=6
    MODE6_NEXT=1
    DELAY=0
    RESCUE_IF="eth3"
    RESCUE_IF_UP="eth3"
    echo '0 255 0' >  /sys/class/leds/rgb\:indicator/multi_intensity
    echo default-on > /sys/class/leds/rgb\:indicator/trigger
    SELECTED_MODE=""
    enable_btrfs
}

check_for_mode_change() { return 1; }

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
    while [ ! -e /busy_stop ]; do
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
    echo 1 > /busy_stop
    case "$1" in
        1) dd if=/usr/share/rescue/internet-err.rgb of=/dev/fb0 > /dev/null 2>&1 ;;
        2) dd if=/usr/share/rescue/medkit-err.rgb of=/dev/fb0 > /dev/null 2>&1 ;;
        *) dd if=/usr/share/rescue/fail.rgb of=/dev/fb0 > /dev/null 2>&1 ;;
    esac
    while true; do
        sleep 1
    done
}

