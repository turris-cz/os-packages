zonename="$(uci -q get 'system.@system[-1].zonename')"
timezone="$(uci -q get 'system.@system[-1].timezone')"
country="$(uci -q get 'system.@system[-1]._country')"
wizard_finished="$(uci -q get 'foris.wizard.finished')"

if [ "$wizard_finished" != "1" ] && { [ -z "$zonename" ] || { [ "$zonename" = "UTC" ] && [ "$timezone" = "GMT0" ]; }; }; then
	uci set 'system.@system[-1].zonename=Europe/Prague'
fi

if [ -z "$country" ]; then
	uci set 'system.@system[-1]._country=CZ'
fi

if [ -n "$(uci changes 'system.@system[-1]')" ]; then
	uci commit 'system.@system[-1]'
fi
