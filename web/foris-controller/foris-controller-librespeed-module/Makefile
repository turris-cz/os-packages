#
# Copyright (C) 2023 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-librespeed-module
PKG_VERSION:=0.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-librespeed-module.git
PKG_MIRROR_HASH:=dc9430b78afd22fa457afb366223c8241cb000ccda32865d16d8ca109ae27781
PKG_SOURCE_VERSION:=3fd355958c73f0ffc76a6cf6013dccd34056c538

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
    +foris-controller \
    +python3-dateutil \
    +librespeed-cli
endef

define Package/foris-controller-librespeed-module/description
  This is a librespeed module for foris-controller.
endef

define Package/foris-controller-librespeed-module/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/foris-controller restart
fi
endef

define ForisControllerModule/foris-controller-librespeed-module/install
	$(INSTALL_DIR) $(1)/etc/config

	$(INSTALL_DATA) ./files/librespeed.uci $(1)/etc/config/librespeed
endef

$(eval $(call ForisControllerModule,foris-controller-librespeed-module))
# call BuildPackage <= assures OWR build system that this is package
