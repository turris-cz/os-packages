#!/usr/bin/env sh

# Copyright (C) 2025 CZ.NIC z.s.p.o. (http://www.nic.cz/)

set -e

HOSTS_PATH="/run/hosts/dhcpv6-dns.hosts"

# Call the odhcpd-provided script
/usr/sbin/odhcpd-update ||:

# Do we even do this?
is_enabled=$(uci get resolver.common.dynamic_domain)
if [[ "${is_enabled}" != @(1|enabled|on|true) ]]; then
	exit 0
fi

# Ask DHCP service for leases
domain=$(uci get dhcp.dnsmasq.domain)
ubus -S call dhcp ipv6leases \
	| jq  -r --arg domain "${domain}" '
		.device.[].leases.[]
			| select(.hostname != null and .hostname != "")
			| "\(.["ipv6-addr"].[]?.address) \(.hostname).\($ARGS.named.domain)"
	' > "${HOSTS_PATH}"

# Inform DNS resolver
prefered_resolver=$(uci get resolver.common.prefered_resolver)
case "${prefered_resolver}" in
	"kresd")
		run_dir=$(uci get resolver.kresd.rundir)
		sock_name=$(ls "${run_dir}/control/" | head -n1)
		if [[ -z "${sock_name}" ]]; then
			echo "kresd is probably not running, no socket found" >&2
		fi

		echo "hints.add_hosts \"${HOSTS_PATH}\"" | socat - UNIX-CONNECT:"${run_dir}/control/${sock_name}"
	;;
	*) echo "unsupported resolver \"${prefered_resolver}\"" >&2 ;;
esac
