#!/bin/sh
LEDS="$(ls -1d /sys/class/leds/rgb\:*)"
LEDS_N="$(echo "$LEDS" | wc -l)"
COLORS="$(uci -q get christmas.christmas.colors)"
[ -n "$COLORS" ] || COLORS="red green blue yellow cyan magenta"
# Not quoting to squash all blanks
COLORS_N="$(echo $COLORS | wc -w)"
# Backward compatibility
SLEEP="$(uci -q get christmas.christmas.sleep_max)"
[ -n "$SLEEP" ] || SLEEP="$(uci -q get christmas.christmas.sleep)"
[ -n "$SLEEP" ] || SLEEP="1"


trap "
if test -x /etc/init.d/led; then
    /etc/init.d/led restart
fi
if test -x /etc/init.d/rainbow; then
    /etc/init.d/rainbow restart
fi
if test -x /etc/init.d/minirainbow; then
    /etc/init.d/minirainbow restart
fi
exit 0;
" 2 3 15

if test -x /etc/init.d/led; then
    /etc/init.d/led stop
fi
if test -x /etc/init.d/rainbow; then
    /etc/init.d/rainbow stop
fi
if test -x /etc/init.d/minirainbow; then
    /etc/init.d/minirainbow stop
    killall minirainbow.sh
fi

color_to_code() {
    case "$1" in
        red)
            echo 255 0 0
            ;;
        green)
            echo 0 255 0
            ;;
        blue)
            echo 0 0 255
            ;;
        yellow)
            echo 255 255 0
            ;;
        cyan)
            echo 0 255 255
            ;;
        magenta)
            echo 255 0 255
            ;;
        white)
            echo 255 255 255
            ;;
        *)
            echo "$1" | sed 's|\(..\)|\1 |g' | while read r g b; do printf '%d %d %d' 0x$r 0x$g 0x$b; done
            ;;
    esac
}

randomize_color() {
    # Not quoting to squash all blanks
    COLOR="$(echo $COLORS | cut -d ' ' -f $((RANDOM % COLORS_N)))"
}

set_led_random_color() {
    led="$(echo $LEDS | cut -d ' ' -f $1)"
    color="$(cat "$led"/multi_intensity)"
    while [ "$color" = "$(cat "$led"/multi_intensity)" ]; do
        randomize_color
        color="$(color_to_code $COLOR)"
    done
    [ "$(cat "$led"/trigger)" = "default-on" ] || \
        echo default-on > "$led"/trigger
    echo "$color" > "$led"/multi_intensity
    [ -z "$BRIGHTNESS" ] || \
        echo "$BRIGHTNESS" > "$led"/brightness
}

BRIGHTNESS="$(uci get rainbow.all.brightness 2> /dev/null)"

for LED in $(seq 0 $LEDS_N); do
    set_led_random_color "$LED"
done

while sleep "$SLEEP"; do
    LED="$((RANDOM % (LEDS_N + 1)))"
    set_led_random_color "$LED"
done
