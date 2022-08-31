# Turris 1.x backend for generic rainbow script
LEDS="wan lan-1 lan-2 lan-3 lan-4 lan-5 wlan power"

# it doesn't matter which led we use here, device always points to the same
# location
SYSFS="/sys/class/leds/rgb:wan/device"

led2sysfs() {
	local led="$1"
	echo "/sys/class/leds/rgb:$led"
}

led_defaults() {
	local led="$1"
	case "$led" in
		power)
			color_r=0 color_g=255 color_b=0
			;;
		lan*|wlan)
			color_r=0 color_g=0 color_b=255
			;;
		wan)
			color_r=0 color_g=255 color_b=255
			;;
	esac
}

get_brightness() {
	local cur
	cur="$(cat "$SYSFS/brightness")"
	echo $cur
}

preapply() {
	/etc/init.d/rainbow-animator pause

	local brightness_level
	# brightness gives us brightness * 32, but sysfs needs $brightness ** 2
	brightness_level=$(( ( $(brightness) / 32 ) ** 2 ))
	# 8 ** 2 = 256, but maximum is 255
	if [ $brightness_level -eq 256 ]; then
		brightness = 255
	fi
	echo $brightness_level > $SYSFS/brightness
}

set_led() {
	local led="$1" r="$2" g="$3" b="$4" mode="$5"
	shift 5

	if [ "$mode" = "auto" ]; then # override auto mode for some
		case "$led" in
			power)
				mode="enable"
				;;
			#wlan*)
			#	local trigger
			#	loadsrc pci
			#	if trigger="$(pci_device_activity_detect "$led" "/sys/bus/pci/devices/0000:0${led#pci}:00.0")"; then
			#		mode="activity"
			#		set "$trigger"
			#	else
			#		mode="disable"
			#	fi
			#	;;
		esac
	fi

	local brightness=1 trigger="none"
	case "$mode" in
		auto)
			case "$led" in
				wlan) trigger="phy0tpt" ;;
				*) trigger="turris1x-cpld" ;;
			esac
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

	local sysfs
	sysfs="$(led2sysfs "$led")"
	# We have to disable trigger first to make sure that changes are correctly
	# applied and not modified by this in the meantime.
	echo "none" > "$sysfs/trigger"
	echo "$brightness" > "$sysfs/brightness"
	echo "$r $g $b" > "$sysfs/multi_intensity"
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
		sysfs="$(led2sysfs "$led")"
		echo "none" > "$sysfs/trigger"
		echo "1" > "$sysfs/brightness"
		echo "0 255 0" > "$sysfs/multi_intensity"
	done
	sleep 1

	for led in $LEDS; do
		sysfs="$(led2sysfs "$led")"
		echo "none" > "$sysfs/trigger"
		echo "1" > "$sysfs/brightness"
		echo "0 0 255" > "$sysfs/multi_intensity"
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
			compat_intensity 7 "$@"
			;;
		get)
			compat_get 7 "$@"
			;;
	esac
	shift $(($# - SHIFTARGS))
	SHIFTARGS=$#
}
