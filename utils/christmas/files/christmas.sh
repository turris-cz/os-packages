#!/bin/sh
LEDS="$(rainbow -l | wc -l)"
LEDS="$((LEDS - 1))"
COLORS="$(uci -q get christmas.christmas.colors)"
[ -n "$COLORS" ] || COLORS="red green blue yellow cyan magenta"
# Not quoting to squash all blanks
COLORS_N="$(echo $COLORS | wc -w)"
# Backward compatibility
SLEEP="$(uci -q get christmas.christmas.sleep_max)"
[ -n "$SLEEP" ] || SLEEP="$(uci -q get christmas.christmas.sleep)"
[ -n "$SLEEP" ] || SLEEP="1"

trap "rainbow reset 2> /dev/null; exit 0;" 2 3 15

randomize_color() {
    # Not quoting to squash all blanks
    COLOR="$(echo $COLORS | cut -d ' ' -f $((RANDOM % COLORS_N)))"
}

set_led_random_color() {
    led="$1"
    randomize_color
    rainbow "led${LED}" enable "$COLOR" 2> /dev/null
}

for LED in $(seq 1 $((LEDS + 1))); do
    set_led_random_color "led$LED"
done

while sleep "$SLEEP"; do
    LED="$((RANDOM % LEDS + 1))"
    set_led_random_color "led$LED"
done
