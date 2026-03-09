#!/bin/sh

. /lib/functions.sh
config_load network
config_get IPADDR lan ipaddr "127.0.0.1"
IPADDR=${IPADDR%/*}
AGH_HTTPS_PORT=444
AGH_HTTP_PORT=81

cat <<EOF
server.modules += ( "mod_redirect" )

# HTTPS request -> forward on https://IP:444/
\$HTTP["scheme"] == "https" {
  \$HTTP["url"] =~ "^/adguardhome(/.*)?\$" {
    url.redirect = ( ".*" => "https://${IPADDR}:${AGH_HTTPS_PORT}/" )
  }
}

# HTTP request -> forward on http://IP:81/
\$HTTP["scheme"] != "https" {
  \$HTTP["url"] =~ "^/adguardhome(/.*)?\$" {
    url.redirect = ( ".*" => "http://${IPADDR}:${AGH_HTTP_PORT}/" )
  }
}
EOF
