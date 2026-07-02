#
# Copyright (C) 2023-2026 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-lte-module
PKG_VERSION:=1.2.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-lte-module.git
PKG_MIRROR_HASH:=9b9a610599aa95ba88e63440c449d007faf3c1e5ee0795360f13c3c84c8c58b8
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-lte-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller LTE module
  DEPENDS:=foris-controller
endef

define Package/foris-controller-lte-module/description
  This is LTE module for foris-controller.
endef

define Package/foris-controller-lte-module/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/foris-controller restart
fi
endef

$(eval $(call ForisControllerModule,foris-controller-lte-module))
# call BuildPackage <= assures OWR build system that this is package
