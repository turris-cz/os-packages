#!/bin/ash
set -eu
loadsrc() {
	. "${0%/*}/$1.sh"
}
loadsrc state

rainbowdir="$(mktemp -d)"
trap 'rm -rf "$rainbowdir"' EXIT

LEDS="power lan-0 lan-1 wlan-1 indicator-1"

fail() {
	echo "$@" >&2
	exit 1
}

cmp_file() (
	local level="$1"
	local slot="$2"
	cat >"$rainbowdir/.cmpfile"
	trap 'rm -f "$rainbowdir/.cmpfile"' EXIT
	diff "$rainbowdir/.cmpfile" "$rainbowdir/$(printf "%03d" "$level")-$slot" \
		|| fail "Files are different"
)


default() {
	true
}
call_for_leds_config_level 50 "default" default
cmp_file 50 "default" <<EOF
-	-	-	-
-	-	-	-
-	-	-	-
-	-	-	-
-	-	-	-
EOF

set_wlan-1() {
	if [ "$led" = "wlan-1" ]; then
		color_r=255
		color_g=0
		color_b=127
		status="auto"
	fi
}
call_for_leds_config_level 51 "wlan-1" set_wlan-1
cmp_file 51 "wlan-1" <<EOF
-	-	-	-
-	-	-	-
-	-	-	-
255	0	127	auto
-	-	-	-
EOF

modify_wlan-1() {
	if [ "$led" = "wlan-1" ]; then
		color_r=0
		color_g=255
		color_b=0
		status="trigger"
		status_args="netdev	wlan-1	link tx rx"
	fi
}
call_for_leds_config_level 51 "wlan-1" modify_wlan-1
cmp_file 51 "wlan-1" <<EOF
-	-	-	-
-	-	-	-
-	-	-	-
0	255	0	trigger	netdev	wlan-1	link tx rx
-	-	-	-
EOF

modify_all() {
	color_r=127
	color_g=128
	color_b=255
	status="auto"
	status_args=""
}
call_for_leds_config_level 49 "all" modify_all
cmp_file 49 "all" <<EOF
127	128	255	auto
127	128	255	auto
127	128	255	auto
127	128	255	auto
127	128	255	auto
EOF


complete_config() {
	local r g b s a
	case "$led" in
		power|lan-0|lan-1|indicator-1)
			r=127
			g=128
			b=255
			s="auto"
			a=""
			;;
		wlan-1)
			r=0
			g=255
			b=0
			s="trigger"
			a="netdev	wlan-1	link tx rx"
			;;
		*)
			fail "Invalid led: $led"
			;;
	esac
	[ "$color_r" = "$r" ] || fail "Red color does not match: $color_r != $r"
	[ "$color_g" = "$g" ] || fail "Green color does not match: $color_g != $g"
	[ "$color_b" = "$b" ] || fail "Blue color does not match: $color_b != $b"
	[ "$status" = "$s" ] || fail "Status does not match: $status != $s"
	[ "$status_args" = "$a" ] || fail "Status arguments does not match: '$status_args' != '$a'"
}
call_for_leds_config complete_config
