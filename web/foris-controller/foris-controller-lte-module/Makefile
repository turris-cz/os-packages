#
# Copyright (C) 2023-2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-lte-module
PKG_VERSION:=1.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-lte-module.git
PKG_MIRROR_HASH:=83200fdcdaf89438cac6b90452e729194474863d80fdf3c33eca6b59e3b99613
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
