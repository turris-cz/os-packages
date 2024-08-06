#!/bin/sh
set -e
. "${0%/*}/common.sh"
. /lib/functions.sh
. /lib/functions/sentinel.sh
. /usr/libexec/sentinel/fwlogs-defaults.sh

allowed_to_run "fwlogs" 2>/dev/null || return 0


config_load "sentinel"
config_get nflog_group fwlogs nflog_group "$DEFAULT_NFLOG_GROUP"
config_get nflog_threshold fwlogs nflog_threshold "$DEFAULT_NFLOG_THRESHOLD"


fwlogs_logging() {
	local config_section="$1"
	local zone enabled
	config_get zone "$config_section" "name"
	config_get_bool enabled "$config_section" "sentinel_fwlogs" "0"
	[ "$enabled" = "1" ] || return 0

	report_operation "Logging of zone '$zone'"
	nft insert rule inet fw4 "drop_from_${zone}" log group "$nflog_group" queue-threshold "$nflog_threshold" comment "!sentinel: fwlogs"
}

config_load "firewall"
config_foreach fwlogs_logging "zone"
