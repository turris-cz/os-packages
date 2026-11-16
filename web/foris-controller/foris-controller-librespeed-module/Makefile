#
# Copyright (C) 2023-2026 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-librespeed-module
PKG_VERSION:=2.0.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-librespeed-module.git
PKG_MIRROR_HASH:=set-once-v2.0.0-is-tagged
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-librespeed-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller librespeed module
  DEPENDS:=\
    +cronie \
    +foris-controller \
    +librespeed-common
endef

define Package/foris-controller-librespeed-module/description
  This is a librespeed module for foris-controller.
endef

define ForisControllerModule/foris-controller-librespeed-module/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-foris-controller-librespeed-module
endef

define Package/foris-controller-librespeed-module/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
	/etc/init.d/foris-controller restart
fi
endef

define Package/foris-controller-librespeed-module/postrm
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
	/etc/init.d/foris-controller restart
fi
endef

$(eval $(call ForisControllerModule,foris-controller-librespeed-module))
# call BuildPackage <= assures OWR build system that this is package
