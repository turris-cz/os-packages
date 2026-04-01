#!/bin/sh

RED="255 0 0"
ORANGE="255 64 0"
GREEN="0 255 0"
CYAN="0 255 255"
BLACK="0 0 0"

WAN_LED="/sys/class/leds/rgb:wan"
WIFI_LED="/sys/class/leds/rgb:wlan"
POWER_LED="/sys/class/leds/rgb:power"

usage() {
    echo "Usage:" >&2
    echo "$0 [--oneshot]"
    echo "  --oneshot   do not start daemons"
}

led_ignored() {
    uci show system | grep led | grep "$1" | grep color
}

set_color() {
    local color="$1"
    local dev="$2"/multi_intensity
    grep -q "$color" "$dev" || echo "$color" > "$dev"
}

wan_status() {
    if led_ignored rgb:wan; then
        return 0;
    fi

    local status="$RED"
    local connectivity="$(check_connection)"

    if led_ignored rgb:wan; then
        return 0;
    fi
    if echo "$connectivity" | grep "DNS: OK"; then
        if echo "$connectivity" | grep "IPv4: OK"; then
            status="$GREEN"
        fi
        if echo "$connectivity" | grep "IPv6: OK"; then
            status="$CYAN"
        fi
    else
        if echo "$connectivity" | grep "IPv4: OK"; then
            status="$ORANGE"
        else
            status="$RED"
        fi
    fi
    set_color "$status" "$WAN_LED"

    [ "$status" = "$GREEN" ] || [ "$status" = "$CYAN" ]
    return $?
}

wifi_status() {
    if led_ignored rgb:wlan; then
        return 0;
    fi
    local status="$BLACK"
    local bands="$(wifi status | jsonfilter -e '$.*.config.band' | sort -u | wc -l)"
    local up="$(wifi status | jsonfilter -e '$.*.up' | grep true | wc -l)"
    local status="$BLACK"
    if [ "$bands" -eq "$up" ] && [ "$bands" -eq "3" ]; then
        status="$CYAN"
    elif [ "$up" -eq 0 ] && [ "$bands" -gt "1" ]; then
        status="$RED"
    elif [ "$((bands - up))" -lt 2 ]; then
        status="$GREEN"
    else
        status="$ORANGE"
    fi
    set_color "$status" "$WIFI_LED"
}

while [ -n "$1" ]; do
    case "$1" in
        "--oneshot")
            ONESHOT=1
            ;;
        *)
            usage
            exit 1
            ;;
    esac
    shift
done

if [ "$ONESHOT" = 1 ]; then
    wifi_status &
    wan_status &
    wait
    exit 0
fi

{
    trap "wan_status" HUP
    while true; do
        if wan_status; then
            # background sleep so that trap works properly
            sleep 300 &
            wait
        else
            sleep 10 &
            wait
        fi
    done
} &
WAN_STATUS_PID="$!"

{
    trap "wifi_status" HUP
    while true; do
        wifi_status
        sleep 10 &
        wait
    done
} &
WIFI_STATUS_PID="$!"

trap "kill $WIFI_STATUS_PID; kill $WAN_STATUS_PID; wait" 2 3 15
wait

