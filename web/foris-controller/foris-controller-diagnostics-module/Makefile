#
# Copyright (C) 2019-2025 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-diagnostics-module
PKG_VERSION:=2.0.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-diagnostics-module.git
PKG_MIRROR_HASH:=12c9544d85cca058f7ad34d2d31819e4bded67935946b5d5b322fdd4658e8624
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-diagnostics-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller Diagnostics module
  DEPENDS:= \
    +foris-controller \
    +turris-diagnostics
endef

define Package/foris-controller-diagnostics-module/description
  This is a diagnostics module for foris-controller.
endef

$(eval $(call ForisControllerModule,foris-controller-diagnostics-module))
# call BuildPackage <= assures OWR build system that this is package
