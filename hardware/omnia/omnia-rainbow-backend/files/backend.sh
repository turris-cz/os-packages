# Turris Omnia backend for generic rainbow script
LEDS="power lan-0 lan-1 lan-2 lan-3 lan-4 wan wlan-1 wlan-2 wlan-3 indicator-1 indicator-2"

SYSFS="/sys/devices/platform/soc/soc:internal-regs/f1011000.i2c/i2c-0/i2c-1/1-002b/leds/rgb"

led_defaults() {
	local led="$1"
	case "$led" in
		power)
			color_r=0 color_g=255 color_b=0
			;;
		lan*|wlan*)
			color_r=0 color_g=0 color_b=255
			;;
		wan)
			color_r=0 color_g=255 color_b=255
			;;
	esac
}

get_brightness() {
	local cur
	cur="$(cat "$SYSFS/global_brightness")"
	echo $((cur * 255 / 100))
}

preapply() {
	/etc/init.d/rainbow-animator pause

	local brightness_level
	brightness_level="$(brightness)"
	# The full range is only 0-100 but that is good enough so we don't adjust
	# more. We just loose the precision on Omnia but who can see it anyway.
	echo "$((brightness_level * 100 / 255))" > "$SYSFS/global_brightness"
}

set_led() {
	local led="$1" r="$2" g="$3" b="$4" mode="$5"
	shift 5

	if [ "$mode" = "auto" ]; then # override auto mode for some
		case "$led" in 
			pwd)
				mode="enable"
				;;
			wlan*)
				local trigger
				loadsrc pci
				if trigger="$(pci_device_activity_detect "$led" "/sys/bus/pci/devices/0000:0${led#pci}:00.0")"; then
					mode="activity"
					set "$trigger"
				else
					mode="disable"
				fi
				;;
			indicator*)
				mode="disable"
				;;
		esac
	fi

	local brightness=255 autonomous=0 trigger="none"
	case "$mode" in
		auto)
			autonomous=1
			;;
		disable)
			brightness=0
			;;
		enable)
			;;
		activity)
			trigger="activity"
			;;
		animate)
			# For animation we rely on animator
			;;
		*)
			internal_error "Unsupported mode:" "$mode"
			;;
	esac

	local sysfs="$SYSFS:$led"
	# We have to disable trigger first to make sure that changes are correctly
	# applied and not modified by this in the meantime.
	echo "none" > "$sysfs/trigger"
	echo "$brightness" > "$sysfs/brightness"
	echo "$r $g $b" > "$sysfs/color"
	echo "$autonomous" > "$sysfs/autonomous"
	if [ "$trigger" = "activity" ]; then
		apply_activity "$led" "$@" \
			|| echo "Warning: activity setup failed for: $led" >&2
	else
		echo "$trigger" > "$sysfs/trigger"
	fi
}

postapply() {
	/etc/init.d/rainbow-animator reload
}


boot_sequence() {
	local sysfs

	for led in $LEDS; do
		sysfs="$SYSFS:$led"
		echo "none" > "$sysfs/trigger"
		echo "0" > "$sysfs/autonomous"
		echo "255" > "$sysfs/brightness"
		echo "0 255 0" > "$sysfs/color"
	done
	sleep 1

	for led in $LEDS; do
		sysfs="$SYSFS:$led"
		echo "0" > "$sysfs/autonomous"
		echo "none" > "$sysfs/trigger"
		echo "255" > "$sysfs/brightness"
		echo "0 0 255" > "$sysfs/color"
	done
	sleep 1
	# Note: we apply in the end so we don't have to restore previous state
}


# Parse operations that were previously available with rainbow
compatibility() {
	local operation="$1"; shift
	SHIFTARGS=$#
	case "$operation" in
		binmask)
			compat_binmask "$@"
			;;
		intensity)
			compat_intensity 100 "$@"
			;;
		get)
			compat_get 100 "$@"
			;;
	esac
	shift $(($# - SHIFTARGS))
	SHIFTARGS=$#
}