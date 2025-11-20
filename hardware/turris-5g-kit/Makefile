#
# Copyright (C) 2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-5g-kit
PKG_VERSION:=v0.4
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/turris-5g-kit
  TITLE:=Support for Turris 5G kit
  DEPENDS:=@(TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia||TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng) \
          +TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia:turris-nor-update \
          +comgt-ncm +mwan3 +watchcat \
          +luci-proto-ncm +luci-app-mwan3 +luci-app-watchcat \
          +kmod-usb-net-cdc-ncm +kmod-usb-serial-option
  PROVIDES:=omnia-5g-kit
  CONFLICTS:=modem-manager-autosetup modem-manager
endef

define Package/turris-5g-kit/description
This package reconfigures GSM network to work with our Quectell RM500U-EA 5G
modem and also connects to the internet on every boot.

On Turris Omnia, it will also reconfigure the internal mPCIe to support USB3
disabling one of the outside USB ports.
endef

define Build/Compile
	true
endef

ifeq ($(CONFIG_TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia),y)
BOARD:=omnia
else
BOARD:=omnia-ng
endif

define Package/turris-5g-kit/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/5g-kit.init $(1)/etc/init.d/5g-kit
	sed -i 's|@BOARD@|${BOARD}|g' $(1)/etc/init.d/5g-kit
	$(INSTALL_DIR) $(1)/etc/hotplug.d/net
	$(INSTALL_BIN) ./files/${BOARD}/hotplug-net-5g-kit $(1)/etc/hotplug.d/net/50-5g-kit
	$(INSTALL_DIR) $(1)/etc/hotplug.d/tty
	$(INSTALL_BIN) ./files/${BOARD}/hotplug-tty-5g-kit $(1)/etc/hotplug.d/tty/50-5g-kit
endef

define Package/turris-5g-kit/postinst
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


define Package/turris-5g-kit/prerm
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
    if [ "${BOARD}" = 'omnia' ]; then
        fw_setenv omnia_wwan_slot pcie
    fi
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
    if [ "${BOARD}" = 'omnia' ]; then
        fw_setenv omnia_wwan_slot pcie > /dev/null 2>&1 < /dev/null
    fi
}
endef

$(eval $(call BuildPackage,turris-5g-kit))
