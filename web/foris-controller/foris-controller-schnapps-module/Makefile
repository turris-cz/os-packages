#
# Copyright (C) 2019-2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-schnapps-module
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-schnapps-module.git
PKG_MIRROR_HASH:=96db1e8d29f211b9943aecc9757e7c8fcdea9147f6ef2f6ea4548d6d6d4e4d91
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-schnapps-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris-controller schnapps module
  DEPENDS:= \
    +foris-controller \
    +schnapps
endef

define Package/foris-controller-schnapps-module/description
  This is a schnapps module for foris-controller.
endef

$(eval $(call ForisControllerModule,foris-controller-schnapps-module))
# call BuildPackage <= assures OWR build system that this is package
