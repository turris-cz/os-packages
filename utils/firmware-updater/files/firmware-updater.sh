#!/bin/sh
[ -z "$ROOT_DIR" ] || [ "$ROOT_DIR" = "/" ] || exit 0
nor-update
[ ! -x /usr/bin/omnia-mcutool ] || omnia-mcutool --upgrade
[ "$(schnapps factory-version | cut -f 1 -d .)"  -eq "$(cat /etc/turris-version | cut -f 1 -d .)" ] || schnapps update-factory
