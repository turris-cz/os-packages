#
# Copyright (C) 2020-2024 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-nextcloud-module
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-nextcloud-module.git
PKG_MIRROR_HASH:=0f4a2e67f6f30521fca5587fa3619b5dcbc93f24bfb0701d63d358303c2a597e
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-nextcloud-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller Nextcloud module
  DEPENDS:= \
    +foris-controller \
    +foris-controller-storage-module \
    +nextcloud-install
endef

define Package/foris-controller-nextcloud-module/description
  This is a nextcloud module for foris-controller.
endef

define Package/foris-controller-nextcloud-module/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/foris-controller restart
fi
endef

$(eval $(call ForisControllerModule,foris-controller-nextcloud-module))
# call BuildPackage <= assures OWR build system that this is package
