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

# This is simple helper to check for existence of given chain
iptables_chain_exists() {
	iptables-legacy -S "$1" >/dev/null 2>&1
}

# This is simple helper to check for existence of given chain
ip6tables_chain_exists() {
	ip6tables-legacy -S "$1" >/dev/null 2>&1
}

# This is simple helper to check for existence of given chain in nat table
iptables_nat_chain_exists() {
	iptables-legacy -t nat -S "$1" >/dev/null 2>&1
}

# This is simple helper to check for existence of given chain in nat table
ip6tables_nat_chain_exists() {
	ip6tables-legacy -t nat -S "$1" >/dev/null 2>&1
}

# Add drop rule
# zone: name of firewall zone incoming packets are coming from
# chain: chain to be affected (input/forward)
# Any additional arguments are passed to iptables call adding this rule
iptables_set_drop() {
	local zone="$1"
	local chain="$2"
	local set="$3"
	shift 3
	local drop_zone="zone_${zone}_src_DROP"

	# fw3 won't create chain for drop if no rule in UCI requires it. This just
	# recreates it if it is missing.
	if ! iptables_chain_exists "$drop_zone"; then
		iptables-legacy -N "$drop_zone"
		iptables-legacy -A "$drop_zone" \
			-m comment --comment "!sentinel" \
			-j DROP
	fi

	iptables-legacy -I "zone_${zone}_${chain}" 1 -m set --match-set "${set}"_v4 src "$@" -j "$drop_zone"

	if ! ip6tables_chain_exists "$drop_zone"; then
		ip6tables-legacy -N "$drop_zone"
		ip6tables-legacy -A "$drop_zone" \
			-m comment --comment "!sentinel" \
			-j DROP
	fi

	if ip6tables_chain_exists "zone_${zone}_${chain}"; then
		ip6tables-legacy -I "zone_${zone}_${chain}" 1  -m set --match-set "${set}"_v6 src "$@" -j "$drop_zone"
	fi
}

ip6tables_nat_wan() {
	local wan_device
	wan_device="$(uci -q get network.wan6.device || true)"
	if [ -z "$wan_device" ] || [ "$wan_device" = "@wan" ]; then
		wan_device="$(uci -q get network.wan.device || true)"
	fi
	if [ -n "$wan_device" ]; then
		ip6tables_nat_chain_exists zone_wan_prerouting || ip6tables-legacy -t nat -N zone_wan_prerouting
		ip6tables-legacy -t nat -S | grep -q '!sentinel: Hacky way to get IPv6 NAT' || \
			ip6tables-legacy -t nat -A PREROUTING -i eth2.5 -m comment --comment "!sentinel: Hacky way to get IPv6 NAT" -j zone_wan_prerouting
	fi
	ip6tables-legacy -S zone_wan_forward | grep -q "!sentinel: Hack to accept port forwards" || \
		ip6tables-legacy -I zone_wan_forward -m conntrack --ctstate DNAT -m mark --mark 0x10/0x10 -m comment --comment "!sentinel: Hack to accept port forwards" -j ACCEPT
	ip6tables-legacy -S zone_wan_input | grep -q "!sentinel: Hack to accept port forwards" || \
		ip6tables-legacy -I zone_wan_input -m conntrack --ctstate DNAT -m mark --mark 0x10/0x10 -m comment --comment "!sentinel: Hack to accept port forwards" -j ACCEPT
}

# Add port redirect rule.
# zone: name of firewall zone incoming packets are coming from
# port: target port of packet
# local_port: local port to redirect packet to
# description: description for this redirect printed and recorded in comment
iptables_redirect() {
	local zone="$1"
	local port="$2"
	local local_port="$3"
	local description="$4"
	local wan_ipv6=""

	wan_ipv6="$(uci -q get sentinel.minipot.ipv6 || true)"
	[ -n "${wan_ipv6}" ] || {
		wan_ipv6="$(ifstatus wan6 | \
			jsonfilter \
				-e '@["ipv6-prefix-assignment"][*]["local-address"].address' \
				-e '@["ipv6-address"][*]["address"]' \
			|| true)"
	}

	report_operation "$description on zone '$zone' ($port -> $local_port)"
	if iptables_nat_chain_exists "zone_${zone}_prerouting"; then
		iptables-legacy -t nat -A "zone_${zone}_prerouting" \
			-p tcp \
			-m tcp --dport "$port" \
			-m comment --comment "!sentinel: $description port redirect" \
			-j REDIRECT --to-ports "$local_port"
	fi
	ip6tables_nat_wan
	for ipv6 in ${wan_ipv6}; do
		if ip6tables_nat_chain_exists "zone_${zone}_prerouting"; then
			ip6tables-legacy -t nat -A "zone_${zone}_prerouting" \
				-d "${ipv6}" \
				-p tcp \
				-m tcp --dport "$port" \
				-m comment --comment "!sentinel: $description port redirect" \
				-j DNAT --to-destination "[${ipv6}]:${local_port}"
		fi
	done
}
