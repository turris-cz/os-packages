#
## Copyright (C) 2021-2024 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-bootstrap-theme
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/bootstrap-theme.git
PKG_MIRROR_HASH:=0ff76ca04dbe177ce1fd88a7ae144782620f3f9b301458229f194063ac92a1c3
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/turris-bootstrap-theme
  SECTION:=web
  CATEGORY:=Web
  TITLE:=Turris Bootstrap Theme
  DEPENDS:=+lighttpd +lighttpd-mod-alias
endef

define Package/turris-bootstrap-theme/description
  Common Turris-specific bootstrap theme.
endef

Build/Compile:=:

define Package/turris-bootstrap-theme/install
	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d
	$(INSTALL_CONF) ./files/lighttpd.conf $(1)/etc/lighttpd/conf.d/70-theme.conf

	$(INSTALL_DIR) $(1)/www/turris-theme
	$(MAKE) -C $(PKG_BUILD_DIR) install NO_BUILD=y INSTALL_DIR=$(1)/www/turris-theme
endef

define Package/turris-bootstrap-theme/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/init.d/lighttpd restart
endef

$(eval $(call BuildPackage,turris-bootstrap-theme))
