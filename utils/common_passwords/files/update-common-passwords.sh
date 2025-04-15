#!/bin/sh

set -e

TMPDIR="/tmp"
CPDIR="/usr/share/common_passwords"


# Sentinel passwords

# Download list from server
curl -o "$TMPDIR/sentinel_passwords.tmp" https://view.sentinel.turris.cz/common_passwords/sentinel_passwords 2> /dev/null

# Update if new list differs
cmp "$TMPDIR/sentinel_passwords.tmp" "$CPDIR/sentinel_passwords" > /dev/null || mv "$TMPDIR/sentinel_passwords.tmp" "$CPDIR/sentinel_passwords"


# HaaS passwords

# Download list from server
curl -o "$TMPDIR/haas_passwords.tmp" https://view.sentinel.turris.cz/common_passwords/haas_passwords 2> /dev/null

# Update if new list differs
cmp "$TMPDIR/haas_passwords.tmp" "$CPDIR/haas_passwords" > /dev/null || mv "$TMPDIR/haas_passwords.tmp" "$CPDIR/haas_passwords"
