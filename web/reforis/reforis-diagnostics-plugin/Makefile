#
# Copyright (C) 2019-2025 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-diagnostics-plugin
PKG_VERSION:=3.2.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-diagnostics
PKG_MIRROR_HASH:=3cdb2d69c59ac4d22ca8be75de7d93100c70d70d9187cbe49e725773d1266f9e
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
