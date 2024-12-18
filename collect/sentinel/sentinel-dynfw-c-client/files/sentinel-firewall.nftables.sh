#!/bin/sh
. "${0%/*}/common.sh"
. /lib/functions.sh

report_operation "Dynamic blocking setup"

config_load "sentinel"

config_get_bool enabled "dynfw" enabled 1
[ "$enabled" -eq 1 ] || return

wl_list_cb() {
    local val="$1"
    if echo "$val" | grep -q "^[0-9.]*$"; then
        nft add element inet turris-sentinel dynfw_4_wl "{ $val }"
    elif echo "$val" | grep -q "^[0-9a-fA-F:]*/*[0-9]*$"; then
        nft add element inet turris-sentinel dynfw_6_wl "{ $val }"
    else
        echo "Invalid ip address $val" >&2
    fi
}

# Recreate the sets
nft add set inet turris-sentinel dynfw_4_wl '{ type ipv4_addr; comment "IPv4 addresses ignored by Turris Sentinel" ; }'
nft add set inet turris-sentinel dynfw_6_wl '{ type ipv6_addr; flags interval; comment "IPv6 addresses ignored by Turris Sentinel" ; }'
nft add set inet turris-sentinel dynfw_4 '{ type ipv4_addr; comment "IPv4 addresses blocked by Turris Sentinel" ; }'
nft add set inet turris-sentinel dynfw_6 '{ type ipv6_addr; flags interval; comment "IPv6 addresses blocked by Turris Sentinel" ; }'

# Fill the whitelist
nft flush set inet "turris-sentinel" dynfw_4_wl 2>/dev/null
nft flush set inet "turris-sentinel" dynfw_6_wl 2>/dev/null
config_list_foreach "dynfw" whitelist wl_list_cb

# Setup the blocking chain
nft flush chain inet turris-sentinel dynfw_block
nft -f - << EOF
table inet turris-sentinel {
        chain dynfw_block {
                ip saddr @dynfw_4_wl accept
                ip6 saddr @dynfw_6_wl accept
                ip saddr @dynfw_4 drop
                ip6 saddr @dynfw_6 drop
        }
}
EOF
