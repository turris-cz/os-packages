#
# Copyright (C) 2020-2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-haas-module
PKG_VERSION:=1.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-haas-module.git
PKG_MIRROR_HASH:=5aba715f5677cb1b746b348192763d25215a8dfdd547156aab9514ff9e08a6d8
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-haas-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller HaaS module
  DEPENDS:=\
    +foris-controller \
    +haas-proxy
endef

define Package/foris-controller-haas-module/description
  This is Honeypot as a Service module for foris-controller.
endef

define Package/foris-controller-haas-module/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/foris-controller restart
fi
endef

$(eval $(call ForisControllerModule,foris-controller-haas-module))
# call BuildPackage <= assures OWR build system that this is package
