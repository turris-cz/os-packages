#!/bin/sh

set -e

SPTEMP=$(mktemp)
HPTEMP=$(mktemp)

CPDIR="/usr/share/common_passwords"

cleanup() {
    rm -f "$SPTEMP" \
          "$HPTEMP"
}

trap 'cleanup' EXIT INT QUIT TERM ABRT


# Sentinel passwords

# Download list from server
[ -e "$SPTEMP" ]
curl -o "$SPTEMP" https://view.sentinel.turris.cz/common_passwords/sentinel_passwords 2> /dev/null

# Update if new list differs
cmp "$SPTEMP" "$CPDIR/sentinel_passwords" > /dev/null || mv "$SPTEMP" "$CPDIR/sentinel_passwords"


# HaaS passwords

# Download list from server
[ -e "$HPTEMP" ]
curl -o "$HPTEMP" https://view.sentinel.turris.cz/common_passwords/haas_passwords 2> /dev/null

# Update if new list differs
cmp "$HPTEMP" "$CPDIR/haas_passwords" > /dev/null || mv "$HPTEMP" "$CPDIR/haas_passwords"
