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

# This is simple helper to check for existence of given table
nftables_portfw_table_exists() {
    nft list table inet turris-sentinel >/dev/null 2>&1
}

# This is simple helper to check for existence of given rule
nftables_portfw_rule_exists() {
    nft list chain inet fw4 input_wan | grep "meta mark 0x00000072" >/dev/null 2>&1
}

# Remove any existing rule
# (firewall4 removes only rules in chains it knows so we have to do this to
# potentially clean after ourselves)
firewall_cleanup() {
    local chain=""
    local handle=""
    local zone="$1"

    report_operation "Cleaning up the remnants of the old firewall"
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

    if ! nftables_portfw_rule_exists; then
        nft delete chain inet fw4 accept_from_wan_minipots 2> /dev/null
        nft delete chain inet turris-sentinel minipots_dstnat 2> /dev/null
        nft delete chain inet turris-sentinel minipots_dstnat_wan 2> /dev/null
    fi
}

# Makes sure we have wan forwarding rule
nftables_set_portfw() {
    local wan_if="$(nft list chain inet fw4 input | grep -Eo "iifname .* jump input_wan" | grep -Eo "\".*\"")"
    local zone="$1"

    # recreates it if it is missing.
    if ! nftables_portfw_table_exists; then
        nft add table inet turris-sentinel
    fi

    # recreates it if it is missing.
    if ! nftables_portfw_rule_exists; then
        nft add chain inet fw4 accept_from_wan_minipots '{ comment "required for sentinel minipots" ; }'

        nft add rule inet fw4 accept_from_wan_minipots iifname { $wan_if } counter \
            comment "\"!sentinel: minipots packet counter\""

        nft insert rule inet fw4 input_wan meta mark 114 counter goto accept_from_wan_minipots \
            comment "\"!sentinel: packet redirection for minipots\""

        nft add chain inet turris-sentinel minipots_dstnat '{ type nat hook prerouting priority dstnat; policy accept; }'
        nft add chain inet turris-sentinel minipots_dstnat_wan

        nft add rule inet turris-sentinel minipots_dstnat iifname { $wan_if } counter jump minipots_dstnat_wan \
            comment "\"!sentinel: port redirection for minipots\""

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
    nft insert rule inet turris-sentinel minipots_dstnat_wan meta nfproto { ipv4, ipv6 } counter \
    tcp dport $port meta mark set 114 redirect to $local_port comment "\"!sentinel: $description port redirect\""
}

