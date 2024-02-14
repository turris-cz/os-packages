#!/bin/sh
[ -z "$ROOT_DIR" ] || [ "$ROOT_DIR" = "/" ] || exit 0
[ "0$(uci get pkglists.firmware_update.nor)" -ne 1 ] || \
    nor-update
[ "0$(uci get pkglists.firmware_update.mcu)" -ne 1 ] || \
    [ ! -x /usr/bin/omnia-mcutool ] || \
    omnia-mcutool --upgrade
[ "0$(uci get pkglists.firmware_update.factory)" -ne 1 ] || \
   [ "$(schnapps factory-version | cut -f 1,2 -d .)" == "$(cut -f 1,2 -d . /etc/turris-version)" ] || \
   schnapps update-factory > /dev/null 2>&1
