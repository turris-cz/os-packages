#
# Copyright (C) 2023-2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-librespeed-module
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-librespeed-module.git
PKG_MIRROR_HASH:=5b71f7f1203a0967721f46d7d4f2a1d95ae1bb1f120cf09220f4801bd187963d
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
	$(INSTALL_DIR) $(1)/usr/libexec/foris-controller
	$(INSTALL_BIN) ./files/librespeed.sh $(1)/usr/libexec/foris-controller/librespeed.sh
	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_DATA) ./files/librespeed.cron $(1)/etc/cron.d/librespeed
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
