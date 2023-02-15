#
# Copyright (C) 2020 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-webapps-miniflux
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/turris-webapps-miniflux
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=WebApps
  TITLE:=Miniflux integration
  DEPENDS:=+miniflux \
    +turris-webapps
  URL:=https://gitlab.nic.cz/turris/webapps
endef

define Package/turris-webapps-miniflux/description
  WebApps integration package for Miniflux.
  See https://miniflux.app/
endef

define Build/Compile
endef

define Package/turris-webapps-miniflux/install
	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d
	$(INSTALL_DATA) ./files/miniflux.lighttpd $(1)/etc/lighttpd/conf.d/miniflux.conf
	$(INSTALL_DIR) $(1)/usr/share/turris-webapps
	$(INSTALL_DATA) ./files/30_miniflux.json $(1)/usr/share/turris-webapps/
	$(INSTALL_DIR) $(1)/www/webapps-icons
	$(INSTALL_DATA) ./files/miniflux.svg $(1)/www/webapps-icons
endef

define Package/turris-webapps-miniflux/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/init.d/lighttpd restart
endef

$(eval $(call BuildPackage,turris-webapps-miniflux))
