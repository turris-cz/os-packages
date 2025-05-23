#
## Copyright (C) 2020 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel-firewall
PKG_VERSION:=0.1.5
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/sentinel-firewall-iptables
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  PROVIDES:=sentinel-firewall
  TITLE:=Turris Sentinel Firewall iptables integration
  DEPENDS:=+firewall +iptables-zz-legacy +ip6tables-zz-legacy
  CONFLICTS:=sentinel-firewall-nftables \
             firewall4
endef

define Package/sentinel-firewall-nftables
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  PROVIDES:=sentinel-firewall
  TITLE:=Turris Sentinel Firewall nftables integration
  DEPENDS:=+firewall4 +nftables
  CONFLICTS:=sentinel-firewall-iptables \
             firewall
endef

Build/Compile:=:

define Package/sentinel-dynfw-cert
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=Certificate for Turris Sentinel Dynamic Firewall
endef


define Package/sentinel-dynfw-cert/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) ./files/server.pub $(1)/etc/sentinel_dynfw_server.pub
endef

define Package/sentinel-firewall-iptables/install
	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/firewall.sh $(1)/usr/libexec/sentinel/
	$(INSTALL_DATA) ./files/common_iptables.sh $(1)/usr/libexec/sentinel/firewall.d/common.sh
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-sentinel-firewall
	$(INSTALL_DIR) $(1)/lib/functions
	$(INSTALL_DATA) ./files/functions.sh $(1)/lib/functions/sentinel-firewall.sh
endef

define Package/sentinel-firewall-nftables/install
	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/firewall.sh $(1)/usr/libexec/sentinel/
	$(INSTALL_DATA) ./files/common_nftables.sh $(1)/usr/libexec/sentinel/firewall.d/common.sh
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-sentinel-firewall
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) ./files/90-wan-ip $(1)/etc/hotplug.d/iface/90-wan-ip
	$(INSTALL_DIR) $(1)/lib/functions
	$(INSTALL_DATA) ./files/functions.sh $(1)/lib/functions/sentinel-firewall.sh
endef

define Package/sentinel-firewall-iptables/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/init.d/firewall restart
endef

define Package/sentinel-firewall-nftables/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/init.d/firewall restart
endef

$(eval $(call BuildPackage,sentinel-firewall-iptables))
$(eval $(call BuildPackage,sentinel-firewall-nftables))
$(eval $(call BuildPackage,sentinel-dynfw-cert))
