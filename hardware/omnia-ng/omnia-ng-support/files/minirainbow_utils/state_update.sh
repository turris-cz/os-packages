#!/bin/sh

. /lib/functions.sh

mkdir -p /tmp/minirainbow

uci_load_led() {
	local color_val
	local brightness
	local sysfs

	set +x
	config_get sysfs $1 sysfs
	[ -z "$sysfs" ] && return 1
	config_get brightness $1 brightness

	dir="/tmp/minirainbow/${sysfs}"
	[ -n "$brightness" ] && {
		echo "$brightness" > "$dir"/brightness
	}

	for color in red green blue; do
		config_get "color_${color}" $1 color_val
		[ -n "$color_val" ] && {
			touch "$dir"/ignore_color
			break
		}
	done
}

if ! uci -q show rainbow.state.dim; then
	touch /etc/config/rainbow
	uci set rainbow.state=state
	uci set rainbow.state.dim=0
fi

for led in $(ls /sys/class/leds/); do
	dir="/tmp/minirainbow/$led"
	mkdir -p "$dir"
	cat "/sys/class/leds/${led}/max_brightness" > "$dir"/brightness
	rm -f "$dir"/ignore_color
done

config_load system
config_foreach uci_load_led led "$1"
uci commit rainbow
