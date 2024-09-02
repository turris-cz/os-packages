#!/bin/sh
set -e
. "${0%/*}/common.sh"
. /lib/functions.sh

dynfw_block() {
    local config_section="$1"
    local zone enabled
    config_get zone "$config_section" "name"
    config_get_bool enabled "$config_section" "sentinel_dynfw" "0"
    [ "$enabled" = "1" ] || return 0

    report_operation "Dynamic blocking on zone '$zone'"

    # Recreate the sets
    nft add set inet turris-sentinel dynfw_4 '{ type ipv4_addr; comment "IPv4 addresses blocked by Turris Sentinel"  ; }'
    nft add set inet turris-sentinel dynfw_6 '{ type ipv6_addr; flags interval; comment "IPv6 addresses blocked by Turris Sentinel" ; }'

    nft add rule inet turris-sentinel dynfw_block_zone_"${zone}" ip saddr @dynfw_4 drop
    nft add rule inet turris-sentinel dynfw_block_zone_"${zone}" ip6 saddr @dynfw_6 drop
}

config_load "firewall"
config_foreach dynfw_block "zone"
