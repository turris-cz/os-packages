#
# Copyright (C) 2019-2024 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-remote-access-plugin
PKG_VERSION:=2.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-remote-access
PKG_MIRROR_HASH:=1aeee97b3d8392a578a1668d6bb29fe8ddfea43bab4c8915285d669ec6e7517d
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
	node/host \
	hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_remote_access

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-remote-access-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis remote access plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-remote-access
  DEPENDS:=\
    +reforis
endef

define Package/reforis-remote-access-plugin/description
  reForis Remote Access Plugin.
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-remote-access-plugin,reforis_remote_access))
# call BuildPackage <= assures OWR build system that this is package
