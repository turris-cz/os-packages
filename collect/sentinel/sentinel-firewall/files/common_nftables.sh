MAGIC_NUMBER="0x00000072"

# These are common helpers for sentinel-firewall scripts.
report_operation() {
    echo "   *" "$@" >&2
}

report_info() {
    echo "     -" "$@" >&2
}

# This exits with non-zero exit code if argument can't be sourced and with zero
# exit code if sourced
source_if_exists() {
    [ -f "$1" ] && source "$1"
}

# Helper function to prepare everything needed for zone to be used by Turris Sentinel
#
# It assumes that everything is in clean state and was flushed before and expects to be run
# once.
setup_zone() {
    local zone="$1"
    local wan_if="$(nft list chain inet fw4 input | sed -n 's|.*iifname \(.*\) jump input_'"$zone"' .*|\1|p')"

    # Add firewall by-pass rules into fw4
    nft insert rule inet fw4 input_"$zone" meta mark "$MAGIC_NUMBER" accept \
        comment "\"!sentinel: packet by-pass for Turris Sentinel minipots\""

    # Setup port-forwarding infrastructure for minipots in turris-sentinel table
    nft delete chain inet turris-sentinel minipots_dstnat_"$zone" 2> /dev/null || :
    nft add chain inet turris-sentinel minipots_dstnat_"$zone" '{ comment "Minipots port forwarding"; }'
    nft add set inet turris-sentinel "${zone}_ips_6" "{ type ipv6_addr; comment \"IPv4 addresses in zone $zone\"  ; }"
    nft add rule inet turris-sentinel minipots_dstnat iifname $wan_if ip6 daddr @${zone}_ips_6 jump minipots_dstnat_"$zone" \
        comment "\"!sentinel: port redirection for minipots\""
    nft add set inet turris-sentinel "${zone}_ips_4" "{ type ipv4_addr; comment \"IPv4 addresses in zone $zone\"  ; }"
    nft add rule inet turris-sentinel minipots_dstnat iifname $wan_if ip daddr @${zone}_ips_4 jump minipots_dstnat_"$zone" \
        comment "\"!sentinel: port redirection for minipots\""
    INTERFACE="$zone" /etc/hotplug.d/iface/90-wan-ip wan

    # Setup blocking infrastructure
    nft delete chain inet turris-sentinel dynfw_block_zone_"$zone" 2> /dev/null || :
    nft delete chain inet turris-sentinel dynfw_block 2> /dev/null || :
    nft add chain inet turris-sentinel dynfw_block '{ comment "DynFW blocking chain"; }'
    for hook in input forward; do
        nft add rule inet turris-sentinel dynfw_block_hook_"${hook}" iifname $wan_if jump dynfw_block \
            comment "\"!sentinel: blocking malicious traffic\""
    done
}

# Remove any existing rule and prepare our table
#
# Firewall4 removes only rules in chains it knows so we have to do this to
# potentially clean after ourselves. We also set-up our own table in consistent
# state so it can be used by follow-up rules
firewall_cleanup() {
    local chain=""
    local handle=""
    report_operation "Checking for currently setup Sentinel rules"
    # Delete all rules marked as !sentinel
    nft -a list table inet fw4 | while read line; do
        local new_chain="$(echo "$line" | sed -n 's|[[:blank:]]*chain \(.*\) {.*|\1|p')"
        if [ -n "$new_chain" ]; then
            chain="$new_chain"
            continue
        fi
        [ -n "$chain" ] || continue
        handle="$(echo "$line" | sed -n 's|.* comment "!sentinel.* # handle \([0-9]*\)|\1|p')"
        [ -n "$handle" ] || continue
        nft delete rule inet fw4 "$chain" handle "$handle"
    done

    # Recreate a clean turris-sentinel table
    nft delete table inet turris-sentinel 2> /dev/null || :
    nft add table inet turris-sentinel
    nft flush table inet turris-sentinel

    # Setup port-forwarding infrastructure for minipots in turris-sentinel table
    nft delete chain inet turris-sentinel minipots_dstnat 2> /dev/null || :
    nft add chain inet turris-sentinel minipots_dstnat '{ type nat hook prerouting priority -105; policy accept; }'
    nft flush chain inet turris-sentinel minipots_dstnat

    # Setup blocking infrastructure
    for hook in input forward; do
        nft delete chain inet turris-sentinel dynfw_block_hook_"${hook}" 2> /dev/null || :
        nft add chain inet turris-sentinel dynfw_block_hook_"${hook}" '{ type filter hook '"$hook"' priority -5; }'
        nft flush chain inet turris-sentinel dynfw_block_hook_"${hook}"
        nft add rule inet turris-sentinel dynfw_block_hook_"${hook}" ct state established accept
    done

    # Add zone specific rules for wan
    setup_zone wan
}

# Add port redirect rule.
# zone: name of firewall zone incoming packets are coming from
# port: target port of packet
# local_port: local port to redirect packet to
# description: description for this redirect printed and recorded in comment
port_redirect() {
    local zone="$1"
    local port="$2"
    local local_port="$3"
    local description="$4"

    report_operation "$description on zone '$zone' ($port -> $local_port)"
    nft insert rule inet turris-sentinel minipots_dstnat_"$zone" meta nfproto \{ ipv4, ipv6 \} \
        tcp dport "$port" meta mark set "$MAGIC_NUMBER" redirect to "$local_port" comment "\"!sentinel: $description port redirect\""
}
