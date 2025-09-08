#!/bin/sh

RED="255 0 0"
ORANGE="255 64 0"
GREEN="0 255 0"
CYAN="0 255 255"
BLACK="0 0 0"

WAN_LED="/sys/class/leds/rgb:wan"
WIFI_LED="/sys/class/leds/rgb:wlan"

set_trigger() {
    local dev="${2}"
    local new_val="${1}"
    grep -q "\\[$new_val\\]" "$dev" || echo "$new_val" > "$dev"
}

set_val() {
    local dev="${2}"
    local new_val="${1}"
    grep -q "$new_val" "$dev" || echo "$new_val" > "$dev"
}

wan_status() {
    if uci show systemn | grep '^system.@led[0-9*].sysfs=.rgb:wan.'; then
        return 0;
    fi
    local connectivity="$(check_connection)"
    local status="$RED"

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
    set_trigger "netdev" "$WAN_LED"/trigger
    set_val "$status" "$WAN_LED"/multi_intensity
    set_val "$(ifstatus wan | jsonfilter -e '@.device')" "$WAN_LED"/device_name
    set_val 1 "$WAN_LED"/link
    set_val 1 "$WAN_LED"/rx
    set_val 1 "$WAN_LED"/tx
    [ "$status" = "$GREEN" ] || [ "$status" = "$CYAN" ]
    return $?
}

wifi_status() {
    if uci show systemn | grep '^system.@led[0-9*].sysfs=.rgb:wlan.'; then
        return 0;
    fi
    local bands="$(wifi status | jsonfilter -e '$.*.config.band' | sort -u | wc -l)"
    local up="$(wifi status | jsonfilter -e '$.*.up' | grep true | wc -l)"
    local color="$BLACK"
    if [ "$bands" -eq "$up" ] && [ "$bands" -eq "3" ]; then
        color="$CYAN"
    elif [ "$up" -eq 0 ] && [ "$bands" -gt "1" ]; then
        color="$RED"
    elif [ "$(bands - up)" -lt 2 ]; then
        color="$GREEN"
    else
        color="$ORANGE"
    fi
    set_trigger "netdev" "$WIFI_LED"/trigger
    set_val "$color" "$WIFI_LED"/multi_intensity
    set_val "$(ifstatus lan | jsonfilter -e '@.device')"  "$WIFI_LED"/device_name
    set_val 1 "$WIFI_LED"/link
    set_val 1 "$WIFI_LED"/rx
    set_val 1 "$WIFI_LED"/tx
}

while true; do
    if wan_status; then
        sleep 300
    else
        sleep 10
    fi
done &
WAN_STATUS_PID="$!"

while true; do
    wifi_status
    sleep 10
done &
WIFI_STATUS_PID="$!"

trap "kill $WIFI_STATUS_PID; kill $WAN_STATUS_PID;" INT
wait
