#
# Copyright (C) 2023 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-librespeed-plugin
PKG_VERSION:=0.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-librespeed
PKG_MIRROR_HASH:=9cbdc83fbe66db3d3489676d23193b4cba0253c6501cde2b03e12930c09e190f
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

HOST_PYTHON3_PACKAGE_BUILD_DEPENDS:=reforis-distutils
PKG_BUILD_DEPENDS:=node/host

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
    +foris-controller-librespeed-module \
    @(TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia||TARGET_mvebu_cortexa53_DEVICE_cznic_turris-mox)
endef

define Package/reforis-librespeed-plugin/description
  reForis LibreSpeed plugin provides a frontend to measure Internet speed, latency, and other details of the selected LibreSpeed server.
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-librespeed-plugin,reforis_librespeed))
# call BuildPackage <= assures OWR build system that this is package
