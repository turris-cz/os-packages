#
# Copyright (C) 2019-2024 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-diagnostics-plugin
PKG_VERSION:=3.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-diagnostics
PKG_MIRROR_HASH:=4bb755dccb80ccfea02479feb00b4a536773f50bdef96cb36bf278fcfd45f3de
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
