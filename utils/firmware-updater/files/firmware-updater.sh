#!/bin/sh
[ -z "$ROOT_DIR" ] || [ "$ROOT_DIR" = "/" ] || exit 0
nor-update
[ ! -x /usr/bin/omnia-mcutool ] || omnia-mcutool --upgrade
[ "$(schnapps factory-version | cut -f 1 -d .)"  -eq "$(cut -f 1 -d . /etc/turris-version)" ] || schnapps update-factory > /dev/null 2>&1
