#
# Copyright (C) 2019 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-collectd-module
PKG_VERSION:=0.2
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-collectd-module.git
PKG_MIRROR_HASH:=d253f7739450fba4545583469f13af4f141aab9864f14df1b24981b39879d514
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PYTHON3_PKG_FORCE_DISTUTILS_SETUP:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-collectd-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller collectd module
  DEPENDS:= \
    +foris-controller \
    +follectd
endef

define Package/foris-controller-collectd-module/description
  This is a collectd module for foris-controller.
endef

$(eval $(call ForisControllerModule,foris-controller-collectd-module))
# call BuildPackage <= assures OWR build system that this is package
