#!/bin/sh

CPDIR="/usr/share/common_passwords"

curl -o "$CPDIR/sentinel_passwords.tmp" https://view.sentinel.turris.cz/common_passwords/sentinel_passwords
mv "$CPDIR/sentinel_passwords.tmp" "$CPDIR/sentinel_passwords"

curl -o "$CPDIR/haas_passwords.tmp" https://view.sentinel.turris.cz/common_passwords/haas_passwords
mv "$CPDIR/haas_passwords.tmp" "$CPDIR/haas_passwords"
