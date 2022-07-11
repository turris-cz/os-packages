#
# Copyright (C) 2022 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=miniflux-install
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/miniflux-install
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=WebApps
  TITLE:=Nextcloud integration
  DEPENDS:=+miniflux \
    +pgsql-server \
	+pgsql-cli-extra
endef

define Package/miniflux-install/description
  Installer script for Miniflux.
endef

define Build/Compile
endef

define Package/miniflux-install/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/miniflux-install.sh $(1)/usr/bin/miniflux-install
endef

$(eval $(call BuildPackage,miniflux-install))
