#
# Copyright (C) 2021-2025 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-auth
PKG_VERSION:=1.3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/turris-auth.git
PKG_MIRROR_HASH:=2d9c0728bf2457a7a4ae2b7ab2693b033d0ba7a3e733c1ee5779fda58191943c
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DEPENDS:= \
	python-markupsafe/host \
	python-hatchling/host \
	python-babel/host

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/turris-auth
  SECTION:=web
  CATEGORY:=Web
  TITLE:=Turris Authentication
  URL:=https://gitlab.nic.cz/turris/turris-auth
  DEPENDS:=\
    +lighttpd-mod-fastcgi \
    +lighttpd-mod-alias \
    +turris-bootstrap-theme \
    +python3-pbkdf2 \
    +python3-flup \
    +python3-jinja2 \
    +python3-uci
endef

define Package/turris-auth/description
  Turris Authentication for web applications. This is login gateway that can be
  optionally added to any web application.
endef

define Py3Package/turris-auth/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d
	$(INSTALL_CONF) ./files/lighttpd.conf $(1)/etc/lighttpd/conf.d/50-turris-auth.conf
	$(INSTALL_DIR) $(1)/etc/config
	touch $(1)/etc/config/turris-auth
endef

define Package/turris-auth/conffiles
/etc/config/turris-auth
endef

define Package/turris-auth/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || /etc/init.d/lighttpd restart
endef

$(eval $(call Py3Package,turris-auth))
$(eval $(call BuildPackage,turris-auth))
$(eval $(call BuildPackage,turris-auth-src))
