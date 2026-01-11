#!/bin/sh

RED="255 0 0"
ORANGE="255 64 0"
GREEN="0 255 0"
CYAN="0 255 255"
BLACK="0 0 0"

WAN_LED="/sys/class/leds/rgb:wan"
WIFI_LED="/sys/class/leds/rgb:wlan"
POWER_LED="/sys/class/leds/rgb:power"

TRIGGERS=no

set_color() {
    local color="$1"
    local dev="$2"
    set_val "$color" "$dev"/multi_intensity
}

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

set_brightness() {
    for i in /sys/class/leds/*; do
        echo "$BRIGHTNESS" > "$i/brightness"
    done
}

wan_status() {
    if uci show systemn 2> /dev/null | grep '^system.@led[0-9*].sysfs=.rgb:wan.'; then
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
    BRIGHTNESS="$(uci get rainbow.all.brightness 2> /dev/null)"
    set_color "$status" "$WAN_LED"
    set_val "$BRIGHTNESS" "$WAN_LED"/brightness
    if [ "$TRIGGERS" = yes ]; then
        set_trigger "netdev" "$WAN_LED"/trigger
        set_val "$(ifstatus wan | jsonfilter -e '@.device')" "$WAN_LED"/device_name
        set_val 1 "$WAN_LED"/link
        set_val 1 "$WAN_LED"/rx
        set_val 1 "$WAN_LED"/tx
    else
        set_trigger "default-on" "$WAN_LED"/trigger
    fi
    [ "$status" = "$GREEN" ] || [ "$status" = "$CYAN" ]
    return $?
}

wifi_status() {
    if uci show system 2> /dev/null | grep '^system.@led[0-9*].sysfs=.rgb:wlan.'; then
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
    BRIGHTNESS="$(uci get rainbow.all.brightness 2> /dev/null)"
    set_color "$color" "$WIFI_LED"
    set_val "$BRIGHTNESS" "$WAN_LED"/brightness
    if [ "$TRIGGERS" = yes ]; then
        set_trigger "netdev" "$WIFI_LED"/trigger
        set_val "$(ifstatus lan | jsonfilter -e '@.device')"  "$WIFI_LED"/device_name
        set_val 1 "$WIFI_LED"/link
        set_val 1 "$WIFI_LED"/rx
        set_val 1 "$WIFI_LED"/tx
    else
        set_trigger "default-on" "$WIFI_LED"/trigger
    fi
}

BRIGHTNESS="$(uci get rainbow.all.brightness 2> /dev/null)"
[ -n "$BRIGHTNESS" ] || BRIGHTNESS=255

if ! uci show system 2> /dev/null | grep '^system.@led[0-9*].sysfs=.rgb:power.'; then
    set_trigger "default-on" "$POWER_LED"/trigger
    set_color "$GREEN" "$POWER_LED"
    set_brightness
fi

uci show rainbow 2> /dev/null | grep -q 'rainbow.all.brightness' || {
    touch /etc/config/rainbow
    uci set rainbow.all=led
    uci set rainbow.all.brightness="$BRIGHTNESS"
    uci commit rainbow
}

{
    trap "set_brightness;" HUP
    set_brightness
    down="false"
    while true; do
        key="$(head -c 48 /dev/input/event0 | hexdump -e '"%02x"' | tail -c +18 | head -c 2)"
        if [ "$key" = 3b ]; then
            if [ "$down" = true ]; then
                down=false
            else
                down=true
                if [ "$BRIGHTNESS" -lt 4 ]; then
                    if [ "$BRIGHTNESS" -eq 0 ]; then
                        BRIGHTNESS=255
                    else
                        BRIGHTNESS=0
                    fi
                else
                    BRIGHTNESS="$((BRIGHTNESS / 2))"
                fi
                uci set rainbow.all.brightness="$BRIGHTNESS"
                uci commit rainbow
                set_brightness
            fi
        fi
    done
} &
BRIGHTNESS_PID="$!"


if ! uci show systemn 2> /dev/null | grep '^system.@led[0-9*].sysfs=.rgb:indicator.'; then
    echo 0 0 0 > /sys/class/leds/rgb:indicator/multi_intensity
fi

{
    trap "wan_status;" HUP
    while true; do
        if wan_status; then
            sleep 300
        else
            sleep 10
        fi
    done
} &
WAN_STATUS_PID="$!"

{
    trap "wifi_status;" HUP
    while true; do
        wifi_status
        sleep 10
    done
} &
WIFI_STATUS_PID="$!"

while sleep 1; do
    set_brightness
done &
BRIGHTNESS_VAL_PID="$!"

trap "kill $WIFI_STATUS_PID; kill $WAN_STATUS_PID; kill $BRIGHTNESS_PID; kill $BRIGHTNESS_VAL_PID; wait" 2 3 15
wait
