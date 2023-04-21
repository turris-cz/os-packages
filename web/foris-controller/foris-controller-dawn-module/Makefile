#
# Copyright (C) 2023 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-dawn-module
PKG_VERSION:=0.0.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-dawn-module.git
PKG_MIRROR_HASH:=6379a120ecaf8064043d736d64f28e97dc69baac17105da8150be4fb602f302f
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-dawn-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller dawn module
  DEPENDS:=\
    +foris-controller \
	+dawn
endef

define Package/foris-controller-dawn-module/description
  This is a dawn module for foris-controller.
endef

# define ForisControllerModule/foris-controller-dawn-module/install
# 	$(INSTALL_DIR) $(1)/usr/libexec/foris-controller
# 	$(INSTALL_BIN) ./files/dawn.sh $(1)/usr/libexec/foris-controller/librespeed.sh
# 	$(INSTALL_DIR) $(1)/etc/cron.d
# 	$(INSTALL_DATA) ./files/dawn.cron $(1)/etc/cron.d/librespeed
# endef

define Package/foris-controller-dawn-module/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
	/etc/init.d/foris-controller restart
fi
endef

define Package/foris-controller-dawn-module/postrm
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
	/etc/init.d/foris-controller restart
fi
endef

$(eval $(call ForisControllerModule,foris-controller-dawn-module))
# call BuildPackage <= assures OWR build system that this is package
