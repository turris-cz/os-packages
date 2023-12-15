#!/bin/sh
[ -z "$ROOT_DIR" ] || [ "$ROOT_DIR" = "/" ] || exit 0
[ "$(uci get pkglist.firmware_update.nor)" -ne 1 ] || \
    nor-update
[ "$(uci get pkglist.firmware_update.mcu)" -ne 1 ] || \
    [ ! -x /usr/bin/omnia-mcutool ] || \
    omnia-mcutool --upgrade
[ "$(uci get pkglist.firmware_update.factory)" -ne 1 ] || \
    [ "$(schnapps factory-version | cut -f 1 -d .)"  -eq "$(cut -f 1 -d . /etc/turris-version)" ] || \
    schnapps update-factory > /dev/null 2>&1
