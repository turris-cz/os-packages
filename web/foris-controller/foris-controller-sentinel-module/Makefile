#
# Copyright (C) 2020-2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-sentinel-module
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-sentinel-module.git
PKG_MIRROR_HASH:=a96b1b57262522b71012594cd911bb49788c5601eeb890138bce5761320897a6
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-sentinel-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller Sentinel module
  DEPENDS:=\
    +foris-controller \
    +sentinel-eula \
    +sentinel-proxy
endef

define Package/foris-controller-sentinel-module/description
  This is a sentinel module for foris-controller.
endef

$(eval $(call ForisControllerModule,foris-controller-sentinel-module))
# call BuildPackage <= assures OWR build system that this is package
