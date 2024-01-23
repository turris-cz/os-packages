#
# Copyright (C) 2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-librespeed-plugin
PKG_VERSION:=0.2.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-librespeed
PKG_MIRROR_HASH:=5c5c744a34280bfe77de998e32bf28b7c29e2860598c1cf42f6058a2f9f55637
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=node/host reforis-distutils/host

PYTHON3_PKG_FORCE_DISTUTILS_SETUP:=1

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
