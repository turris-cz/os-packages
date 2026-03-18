#!/bin/sh

/usr/libexec/minirainbow/state_update.sh

dim_state=$(uci get rainbow.state.dim)
for led in $(ls /tmp/minirainbow); do
	dir="/tmp/minirainbow/${led}"
	brightness_default=$(cat "$dir"/brightness)
	brightness=$((${brightness_default}/(2**${dim_state})))
	echo "$brightness" > "/sys/class/leds/${led}/brightness"
done
