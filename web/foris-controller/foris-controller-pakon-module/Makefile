#
# Copyright (C) 2018-2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-pakon-module
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-pakon-module.git
PKG_MIRROR_HASH:=7c1f120f3cbe5518cef5513d20e858a9652f09248ea8b8cf848965929da85dbb
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-pakon-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=foris-controller-pakon-module
  DEPENDS:= \
    +foris-controller \
    +pakon
endef

define Package/foris-controller-pakon-module/description
  This is a pakon module for foris-controller.
endef

$(eval $(call ForisControllerModule,foris-controller-pakon-module))
# call BuildPackage <= assures OWR build system that this is package
