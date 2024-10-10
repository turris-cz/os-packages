#!/bin/sh
# This script is intended to be called from firewall3 as a hook.
# Make sure that you have following section at the end of /etc/config/firewall:
#   config include 'sentinel_firewall'
#		option type 'script'
#		option path '/usr/libexec/sentinel/firewall.sh'
#		option family 'any'
#		option reload '1'


# Make sure that we are last config.
# We have to be last config to ensure that we can reliably insert general block
# rules for dynamic firewall and other hacks.
# This is not ideal as we won't apply it in this run but rather by subsequent one
# but that is enough to ensure that we are last in the end.
uci -q reorder "firewall.sentinel_firewall=$(uci show firewall | grep -cE '^firewall\.[^.]+=')"
if [ -n "$(uci changes firewall.sentinel_firewall)" ]; then
	uci commit firewall.sentinel_firewall
	echo "Warning: Sentinel-firewall include reordered: another firewall reload suggested!"
fi

. /usr/libexec/sentinel/firewall.d/common.sh

# Remove any existing rule
firewall_cleanup

# Run all sentinel firewall scripts
cd /usr/libexec/sentinel/firewall.d
for module in ./[0-9]*; do
	[ -x "$module" ] || continue
	"$module"
done
