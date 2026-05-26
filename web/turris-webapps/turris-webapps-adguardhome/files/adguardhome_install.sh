#!/bin/sh

# This script is useful for first initialization of AdguardHome
# It redirects all traffic from LAN network from port 53 to port 54,
# where AdguardHome listens.

if [[ $1 -eq 1 ]];then
  LOCAL_NET=$(uci get network.lan.ipaddr)

  sed -i "s|address: XXX.XXX.XXX.XXX:XX|address: ${LOCAL_NET}:81|" /etc/adguardhome/adguardhome.yaml
  sed -i -E 's/^([[:space:]]*port:[[:space:]]*)XX([[:space:]]*(#.*)?)$/\153\2/' /etc/adguardhome/adguardhome.yaml

  sed -i 's|^\([[:space:]]*option[[:space:]]\+config[[:space:]]\+\)/etc/adguardhome\.yaml[[:space:]]*$|\1/etc/adguardhome/adguardhome.yaml|' /etc/config/adguardhome
  sed -i 's|^\([[:space:]]*option[[:space:]]\+workdir[[:space:]]\+\)/var/lib/adguardhome[[:space:]]*$|\1/srv/services/adguardhome|' /etc/config/adguardhome

  awk 'BEGIN{c=0} /BEGIN CERTIFICATE/{c=1} c{print} /END CERTIFICATE/{c=0}' \
    /etc/lighttpd-self-signed.pem > /etc/adguardhome/adguardhome.crt

  awk 'BEGIN{k=0} /BEGIN (RSA |EC )?PRIVATE KEY/{k=1} k{print} /END (RSA |EC )?PRIVATE KEY/{k=0}' \
    /etc/lighttpd-self-signed.pem > /etc/adguardhome/adguardhome.key 

  chmod 600 /etc/adguardhome/adguardhome.key


  uci set resolver.common.port='54'
  uci commit resolver
  sed -i "s/\(net\.listen('\$addr',[[:space:]]*\)853\([[:space:]]*,[[:space:]]*{[[:space:]]*kind[[:space:]]*=[[:space:]]*'tls'[[:space:]]*}[[:space:]]*)\)/\1854\2/" /etc/init.d/kresd
  chmod 755 /etc/hotplug.d/iface/99-adguard-update
  /etc/init.d/kresd restart
  /etc/init.d/adguardhome start
  /etc/init.d/adguardhome enable
  /etc/init.d/lighttpd restart

elif [[ $1 -eq 2 ]];then

  uci set resolver.common.port='53'
  uci commit resolver
  sed -i "s/\(net\.listen('\$addr',[[:space:]]*\)854\([[:space:]]*,[[:space:]]*{[[:space:]]*kind[[:space:]]*=[[:space:]]*'tls'[[:space:]]*}[[:space:]]*)\)/\1853\2/" /etc/init.d/kresd
  /etc/init.d/kresd restart
  /etc/init.d/adguardhome stop
  /etc/init.d/adguardhome disable 

  rm -rf /etc/adguardhome
fi
