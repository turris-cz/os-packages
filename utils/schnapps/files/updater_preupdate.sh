#!/bin/sh
[ "$ROOT_DIR" = "/" ] || exit 0
[ "$(findmnt -nf -o FSTYPE /)" = "btrfs" ] || exit 0
source /etc/os-release
branch="$(uci get updater.turris.branch)"
schnapps create -t pre "Automatic pre-update snapshot ($PRETTY_NAME - $branch)"
