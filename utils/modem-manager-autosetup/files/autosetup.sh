#!/bin/sh

get_settings() {
    APN="internet"
    USER=""
    PASSWORD=""
    [ -n "$1" ] || return
    local mcc="$(echo "$1" | head -c 3)"
    local mnc="$(echo "$1" | tail -c +4)"
    local imsi="$2"
    local info="$(jq '.apns.apn[] | select(.mcc == "'"$mcc"'" and .mnc == "'"$mnc"'" and has("type") and (.type | contains("default")))' < /usr/share/modem-manager-autosetup/apns-conf.json)"
    [ -n "$info" ] || info="$(jq '.apns.apn[] | select(.mcc == "'"$mcc"'" and .mnc == "'"$mnc"'")' < /usr/share/modem-manager-autosetup/apns-conf.json)"
    if [ -n "$info" ] && [ -n "$imsi" ]; then
        local tmp="$(echo "$info" | jq 'select(.mvno_match_data? and .mvno_type? == "imsi") | select(.mvno_match_data as $mvno | "'"$imsi"'" | startswith($mvno))')"
        [ -z "$tmp" ] || info="$tmp"
    fi
    if [ -n "$info" ]; then
        info="$(echo "$info" | jq -s '.[0]')"
        APN="$(echo "$info" | jq -r .apn)"
        USER="$(echo "$info" | jq -r .user)"
        PASSWORD="$(echo "$info" | jq -r .password)"
    fi
}

get_operator_info() {
    mmcli -i 0 -K | sed -n 's|^sim.properties.operator-code[[:blank:]]*:[[:blank:]]*||p'
}

get_imsi() {
    mmcli -i 0 -K | sed -n 's|^sim.properties.imsi[[:blank:]]*:[[:blank:]]*||p'
}

disable_and_exit() {
    rm -f /etc/cron.d/modem-manager-autosetup
    exit 0
}

check_config() {
    if uci show network | grep -q 'network\..*\.proto=.modemmanager.'; then
        disable_and_exit
    fi
    if uci show network | grep -q 'network\..*\.proto=.qmi.'; then
        disable_and_exit
    fi
    if uci show network | grep -q 'network\..*\.proto=.3g.'; then
        disable_and_exit
    fi
}

set_configs() {
    if ! uci -q get network.gsm; then
        uci batch << EOF
            set network.gsm=interface
            set network.gsm.apn="$APN"
            set network.gsm.proto="modemmanager"
            set network.gsm.device="$(mmcli -m 0 -K | sed -n 's|modem.generic.device[[:blank:]]*:[[:blank:]]*||p')"
            set network.gsm.iptype="ipv4v6"
            set network.gsm.metric="2048"
EOF
        if [ -n "$USER" ] && [ "$USER" != null ]; then
            uci set network.gsm.user="$USER"
        fi
        if [ -n "$PASSWORD" ] && [ "$PASSWORD" != null ]; then
            uci set network.gsm.password="$PASSWORD"
        fi
        uci commit network
        ifup gsm
    fi
    local zone="$(uci show firewall | sed -n 's|^\(firewall\.@zone.*\)\.name=.wan.$|\1|p')"
    if [ -n "$zone" ]; then
        if uci show "$zone.network" | grep "='[^[:blank:]']\\+[[:blank:]][^[:blank:]']\\+.*'"; then
            uci set "$zone.network='$(uci get "$zone.network") gsm'"
        else
            uci add_list "$zone.network=gsm"
        fi
        uci commit firewall
    fi
}

check_config
OPERATOR="$(get_operator_info)"
IMSI="$(get_imsi)"
[ -n "$OPERATOR" ] || exit 0
get_settings "$OPERATOR" "$IMSI"
[ -n "$APN" ] || exit 0
set_configs
