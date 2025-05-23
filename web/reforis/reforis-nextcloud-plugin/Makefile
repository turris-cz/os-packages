#
# Copyright (C) 2022-2025 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-nextcloud-plugin
PKG_VERSION:=1.3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-nextcloud
PKG_MIRROR_HASH:=5df1be1e94197445e88b983e22368e060e6986fecb14cfe956d107514b7f1f90
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
      node/host \
      hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_nextcloud

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
