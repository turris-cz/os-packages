#!/bin/sh

. /lib/functions.sh

config_load network
config_get IPADDR lan ipaddr "127.0.0.1"

cat << EOF
\$HTTP["url"] =~ "^/tvheadend" {
    proxy.header = (
     "map-host-request" => ( "-" => "$IPADDR" ),
     "map-urlpath" => ( "/tvheadend" => "", "/tvheadend/" => "/" ),
     "https-remap" => "enable"
   )
   proxy.server = ( "" => ( ( "host" => "$IPADDR", "port" => "9981") ) )
}
EOF
