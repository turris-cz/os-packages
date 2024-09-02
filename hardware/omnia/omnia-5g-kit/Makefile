#
# Copyright (C) 2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=omnia-5g-kit
PKG_VERSION:=v0.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/omnia-5g-kit
  TITLE:=Support for Turris Omnia 5G kit
  DEPENDS:=@TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia \
          +turris-nor-update \
          +mwan3 +watchcat \
          +luci-app-mwan3 +luci-app-watchcat \
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
endef

define Package/omnia-5g-kit/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
	/etc/init.d/5g-kit start
	uci batch << EOF
delete network.gsm
set network.gsm=interface
set network.gsm.proto='dhcp'
set network.gsm.device='usb0'
set network.gsm.metric=2048
set network.gsm.ip6ifaceid='eui64'
set network.gsm.ip6assign='64
set network.gsm6=interface
set network.gsm6.device='@gsm'
set network.gsm6.proto='dhcpv6'
set watchcat.5gkit='watchcat'
set watchcat.5gkit.period='30s'
set watchcat.5gkit.mode='restart_iface
set watchcat.5gkit.pinghosts='1.1.1.1 8.8.8.8 9.9.9.9'
set watchcat.5gkit.interface='usb0'
EOF
}
endef


define Package/omnia-5g-kit/prerm
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
	fw_setenv omnia_wwan_slot pcie
	uci -q delete network.gsm
	uci -q delete network.gsm6
	uci -q delete watchcat.5gkit
}
endef

$(eval $(call BuildPackage,omnia-5g-kit))
