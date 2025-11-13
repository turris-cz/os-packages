#
# Copyright (C) 2024-2025 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-librespeed-plugin
PKG_VERSION:=1.4.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-librespeed
PKG_MIRROR_HASH:=df3f50edb40795c9c6640c4a954cc5200d0962e1cedc6be036251ad99cd1b28b
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=node/host hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_librespeed

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-librespeed-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis librespeed plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-librespeed
  DEPENDS:=\
    +reforis\
    +foris-controller-librespeed-module
endef

define Package/reforis-librespeed-plugin/description
  reForis LibreSpeed plugin provides a frontend to measure Internet speed, latency, and other details of the selected LibreSpeed server.
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-librespeed-plugin,reforis_librespeed))
# call BuildPackage <= assures OWR build system that this is package
