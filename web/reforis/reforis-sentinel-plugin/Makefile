#
# Copyright (C) 2020-2025 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-sentinel-plugin
PKG_VERSION:=2.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-sentinel
PKG_MIRROR_HASH:=a9d7bac416a1ddb3a43fb60f442a0c32e47c6f4595b21c8cbb9ccf3b81c1b6ea
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
	node/host \
	hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_sentinel

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-sentinel-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis Sentinel plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-sentinel
  DEPENDS:=\
    +reforis \
    +foris-controller-sentinel-module
endef

define Package/reforis-sentinel-plugin/description
  reForis Sentinel plugin
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-sentinel-plugin,reforis_sentinel))
# call BuildPackage <= assures OWR build system that this is package
