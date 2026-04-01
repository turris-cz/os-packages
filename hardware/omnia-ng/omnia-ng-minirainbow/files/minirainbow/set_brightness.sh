#!/bin/sh

if ! uci -q show rainbow.state.dim; then
        touch /etc/config/rainbow
        uci set rainbow.state=state
        uci set rainbow.state.dim=0
fi

dim_state=$(uci get rainbow.state.dim)

if [ "$1" = "--increase-dim" ]; then 
        dim_state=$((dim_state+1))
        if [ "$dim_state" -ge 8 ]; then
            dim_state=0
        fi
        uci set rainbow.state.dim="$dim_state"
        uci commit rainbow
fi

brightness_array="100 70 40 25 12 5 1 0"
set $brightness_array
shift $dim_state
echo "$1" > /sys/class/leds/rgb:power/device/brightness
