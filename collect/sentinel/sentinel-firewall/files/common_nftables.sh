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

# Remove any existing rule
# (firewall4 removes only rules in chains it knows so we have to do this to
# potentially clean after ourselves)
firewall_cleanup() {
    local table=""
    local chain=""
    local handle=""
    report_operation "Cleaning up the remnants of the old firewall"
    nft -a list ruleset | while read line; do
    local new_table="$(echo "$line" | sed -n 's|table inet \(.*\) {.*|\1|p')"
        if [ -n "$new_table" ]; then
            table="$new_table"
            if [ "$table" = turris-sentinel ]; then
                handle="$(echo "$line" | sed -n 's|.* # handle \([0-9]*\)|\1|p')"
                nft delete table inet handle "$handle"
            fi
            continue
        fi
        [ "$table" = fw4 ] || continue
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
    nftables_set_portfw
}

# This is simple helper to check for existence of given chain
nftables_portfw_chain_exists() {
    nft list chain inet fw4 input_wan | grep "ct status dnat" >/dev/null 2>&1
}

# Makes sure we have wan forwarding rule
nftables_set_portfw() {
    local wan_if="$(nft list chain inet fw4 input | sed -n 's|.*iifname \("[^"]*"\) jump input_wan.*|\1|p')"
    
    # recreates it if it is missing.
    if ! nftables_portfw_chain_exists; then
        nft insert rule inet fw4 input_wan ct status dnat counter accept \
        comment "\"!sentinel: enable port forwarding\""

        nft add chain inet fw4 dstnat_wan 2> /dev/null || :

        nft add rule inet fw4 dstnat meta iifname { $wan_if } \
            counter jump dstnat_wan comment \
            "\"!sentinel: forward for interface(s) in wan zone meta packets to dstnat_wan chain\""
    fi
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

    nftables_set_portfw
    report_operation "$description on zone '$zone' ($port -> $local_port)"
    nft add rule inet fw4 "dstnat_$zone" meta nfproto { ipv4, ipv6 } counter \
        tcp dport $port redirect to $local_port comment "\"!sentinel: $description port redirect\""
}                                                                                                           

