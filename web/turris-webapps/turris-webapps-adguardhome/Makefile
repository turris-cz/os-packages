#
# Copyright (C) 2020-2026 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-webapps-adguardhome
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/turris-webapps-adguardhome
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=WebApps
  TITLE:=Adguardhome integration
  DEPENDS:=+adguardhome \
    +turris-webapps \
    +lighttpd-mod-proxy
  URL:=https://gitlab.nic.cz/turris/webapps
endef

define Package/turris-webapps-adguardhome/description
  Webapps integration package for Adguardhome.
  See https://adguard.com/en/adguard-home/overview.html
endef

define Build/Compile
endef

define Package/turris-webapps-adguardhome/install
	$(INSTALL_DIR) $(1)/usr/share/turris-webapps
	$(INSTALL_DATA) ./files/30_adguardhome.json $(1)/usr/share/turris-webapps/

	$(INSTALL_DIR) $(1)/www/webapps-icons
	$(INSTALL_DATA) ./files/adguardhome-black.svg $(1)/www/webapps-icons

	$(INSTALL_DIR) $(1)/usr/libexec/services/
	$(INSTALL_DATA) ./files/adguardhome-dynamic.sh $(1)/usr/libexec/services/adguardhome-dynamic

	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d
	$(INSTALL_DATA) ./files/adguardhome.lighttpd $(1)/etc/lighttpd/conf.d/80-adguardhome.conf

	$(INSTALL_DIR) $(1)/etc/adguardhome/
	$(INSTALL_CONF) ./files/adguardhome.yaml $(1)/etc/adguardhome/adguardhome.yaml
	$(INSTALL_CONF) ./files/adguardhome_install.sh $(1)/etc/adguardhome/adguardhome_install.sh

	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface/
	$(INSTALL_DATA) ./files/99-adguard-update $(1)/etc/hotplug.d/iface/99-adguard-update
endef

define Package/turris-webapps-adguardhome/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/adguardhome/adguardhome_install.sh 1
endef

define Package/turris-webapps-adguardhome/prerm
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/adguardhome/adguardhome_install.sh 2
endef

$(eval $(call BuildPackage,turris-webapps-adguardhome))
