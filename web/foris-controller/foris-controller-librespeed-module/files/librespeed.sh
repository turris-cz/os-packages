#!/bin/sh

. /lib/functions.sh


trigger_measurement () {
	config_load "librespeed"

	local enabled
	config_get_bool enabled "client" "autostart_enabled" "0"

	[ "$enabled" == "1" ] || return 0

	local data_dir
	config_get_bool data_dir "client" "data_dir" "/tmp/librespeed-data/"

	turris-librespeed --data-dir "$data_dir"
}

trigger_measurement
