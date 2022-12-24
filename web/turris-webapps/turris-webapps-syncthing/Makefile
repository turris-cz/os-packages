#
# Copyright (C) 2022 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-webapps-syncthing
PKG_VERSION:=1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/turris-webapps-syncthing
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=WebApps
  TITLE:=syncthing integration
  DEPENDS:=+syncthing \
    +turris-webapps
  URL:=https://gitlab.nic.cz/turris/webapps
endef

define Package/turris-webapps-syncthing/description
  WebApps integration package for syncthing.
  See https://syncthing.net/
endef

define Build/Compile
endef

define Package/turris-webapps-syncthing/install
	$(INSTALL_DIR) $(1)/usr/share/turris-webapps
	$(INSTALL_DATA) ./files/31_syncthing.json $(1)/usr/share/turris-webapps/
	$(INSTALL_DIR) $(1)/www/webapps-icons
	$(INSTALL_DATA) ./files/syncthing.svg $(1)/www/webapps-icons
endef

$(eval $(call BuildPackage,turris-webapps-syncthing))
