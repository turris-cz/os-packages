#!/bin/sh

. /usr/share/libubox/jshn.sh

peer="$1"
user="$2"
password="$3"

[ -n "$peer" -o -n "$user" ]  || exit 1  # password can be empty

echo "Ower #$peer# #$user# #$password#"


# notify foris-controller
json_init
echo "Ower #$peer# #$user# #$password#"
json_add_string peer "$peer"
echo "Ower #$peer# #$user# #$password#"
json_add_string user "$user"
echo "Ower #$peer# #$user# #$password#"
json_add_string password "$password"
echo "Ower #$peer# #$user# #$password#"

echo /usr/bin/foris-notify-wrapper -m haas -a login_attempt "$(json_dump)"
