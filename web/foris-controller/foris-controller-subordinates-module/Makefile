#
# Copyright (C) 2019 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-subordinates-module
PKG_VERSION:=0.2.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-subordinates-module.git
PKG_MIRROR_HASH:=71b55614c0f0fc56e5c81c265078de30d88242bfd320fc26cbcdfcec7909e830
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PYTHON3_PKG_FORCE_DISTUTILS_SETUP:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-subordinates-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller Subordinates module
  DEPENDS:=\
    +foris-controller \
    +foris-forwarder \
    +fosquitto
endef

define Package/foris-controller-subordinates-module/description
  This is a subordinates module for foris-controller.
endef

$(eval $(call ForisControllerModule,foris-controller-subordinates-module))
# call BuildPackage <= assures OWR build system that this is package
