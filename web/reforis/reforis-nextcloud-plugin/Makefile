#
# Copyright (C) 2022 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-nextcloud-plugin
PKG_VERSION:=0.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-nextcloud
PKG_MIRROR_HASH:=4e35c86c4b3d0a179f921d19721d6be130f2ab222c984c2fdb2e617daedffe7e
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

HOST_PYTHON3_PACKAGE_BUILD_DEPENDS:=reforis-distutils
PKG_BUILD_DEPENDS:=node/host

PYTHON3_PKG_FORCE_DISTUTILS_SETUP:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-nextcloud-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis Nextcloud plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-nextcloud
  DEPENDS:=\
    +reforis \
    +foris-controller-nextcloud-module
endef

define Package/reforis-nextcloud-plugin/description
  reForis Nextcloud plugin
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-nextcloud-plugin,reforis_nextcloud))
# call BuildPackage <= assures OWR build system that this is package
