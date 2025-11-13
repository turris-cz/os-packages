#
# Copyright (C) 2019-2025 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-diagnostics-plugin
PKG_VERSION:=3.3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-diagnostics
PKG_MIRROR_HASH:=0e43f432e1ad805dab210f58f9e0d01ce2d1f3a2a0e6a88d88f3cbdc334c6ab1
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
	node/host \
	hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_diagnostics

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-diagnostics-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis diagnostics plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-diagnostics
  DEPENDS:= \
    +reforis \
    +foris-controller-diagnostics-module
endef

define Package/reforis-diagnostics-plugin/description
  reForis diagnostics plugin.
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-diagnostics-plugin,reforis_diagnostics))
# call BuildPackage <= assures OWR build system that this is package
