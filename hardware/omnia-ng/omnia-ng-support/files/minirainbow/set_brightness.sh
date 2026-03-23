#!/bin/sh
set -x

if ! uci -q show rainbow.state.dim; then
        touch /etc/config/rainbow
        uci set rainbow.state=state
        uci set rainbow.state.dim=0
fi

dim_state=$(uci get rainbow.state.dim)

[ "$1" = "--increase-dim" ] && {
        dim_state=$((dim_state+1))
        [ "$dim_state" -ge 8 ] && dim_state=0
}

brightness_array="100 70 40 25 12 5 1 0"
set $brightness_array
shift $dim_state
echo "$1" > /sys/class/leds/rgb:power/device/brightness

uci set rainbow.state.dim="$dim_state"
uci commit rainbow
