#
# Copyright (C) 2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=omnia-5g-kit
PKG_VERSION:=v0.3
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/omnia-5g-kit
  TITLE:=Support for Turris Omnia 5G kit
  DEPENDS:=@TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia \
          +turris-nor-update \
          +comgt-ncm +mwan3 +watchcat \
          +luci-proto-ncm +luci-app-mwan3 +luci-app-watchcat \
          +kmod-usb-net-cdc-ncm +kmod-usb-serial-option
  CONFLICTS:=modem-manager-autosetup modem-manager
endef

define Package/omnia-5g-kit/description
This package switches internal mPCIe slot into USB3 mode, reconfigures GSM
network to work with our Quectell RM500U-EA 5G modem and also connects to the
internet on every boot.
endef

define Build/Compile
	true
endef

define Package/omnia-5g-kit/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/5g-kit.init $(1)/etc/init.d/5g-kit
	$(INSTALL_DIR) $(1)/etc/hotplug.d/net
	$(INSTALL_BIN) ./files/hotplug-net-5g-kit $(1)/etc/hotplug.d/net/50-5g-kit
	$(INSTALL_DIR) $(1)/etc/hotplug.d/tty
	$(INSTALL_BIN) ./files/hotplug-tty-5g-kit $(1)/etc/hotplug.d/tty/50-5g-kit
endef

define Package/omnia-5g-kit/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
    /etc/init.d/5g-kit restart
    [ "$$(uci get network.gsm.proto)" = "ncm" ] || {
        uci -q delete network.gsm || :
        uci batch << EOF
set network.gsm=interface
set network.gsm.proto='ncm'
set network.gsm.ipv6='auto'
set network.gsm.pdptype='IPV4V6'
set network.gsm.apn='internet'
set network.gsm.device='/dev/tty5G3'
set network.gsm.metric=2048
EOF
        uci commit network
    }
    uci -q delete watchcat.5gkit || :
    uci batch << EOF
set watchcat.5gkit='watchcat'
set watchcat.5gkit.period='2m'
set watchcat.5gkit.mode='restart_iface'
set watchcat.5gkit.pinghosts='1.1.1.1 8.8.8.8 9.9.9.9'
set watchcat.5gkit.interface='usb_5g'
set watchcat.5gkit.logical_interface='gsm'
EOF
    uci commit watchcat
    zone="$$(uci show firewall | sed -n 's|^\(firewall\.@zone.*\)\.name=.wan.$$|\1|p')"
    if [ -n "$$zone" ]; then
        if uci show "$$zone.network" | grep "='[^[:blank:]']\\+[[:blank:]][^[:blank:]']\\+.*'"; then
            uci set "$$zone.network='$$(uci get "$$zone.network") gsm gsm6'"
        else
            uci add_list "$$zone.network=gsm"
        fi
        uci commit firewall
    fi
}
endef


define Package/omnia-5g-kit/prerm
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
    fw_setenv omnia_wwan_slot pcie
    uci -q delete network.gsm || :
    uci -q delete network.gsm6 || :
    uci -q delete watchcat.5gkit || :
    uci commit network
    uci commit watchcat
    zone="$$(uci show firewall | sed -n 's|^\(firewall\.@zone.*\)\.name=.wan.$$|\1|p')"
    if [ -n "$$zone" ]; then
        if uci show "$$zone.network" | grep "='[^[:blank:]']\\+[[:blank:]][^[:blank:]']\\+.*'"; then
            uci set "$$zone.network='$$(uci get "$$zone.network" | sed 's| gsm gsm6||')'"
        else
            uci del_list "$$zone.network=gsm"
            uci del_list "$$zone.network=gsm6"
        fi
        uci commit firewall
    fi
    fw_setenv omnia_wwan_slot pcie > /dev/null 2>&1 < /dev/null
}
endef

$(eval $(call BuildPackage,omnia-5g-kit))
