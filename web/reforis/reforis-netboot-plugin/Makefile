#
# Copyright (C) 2020-2025 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-netboot-plugin
PKG_VERSION:=1.3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-netboot
PKG_MIRROR_HASH:=f390eb613cb13d1204e8f2ea853870decd43926982d333f8911b8ab95d2d49de
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
	node/host \
	hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_netboot

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-netboot-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis Netboot plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-netboot
  DEPENDS:=\
    +reforis \
    +reforis-remote-devices-plugin \
    +foris-controller-netboot-module
endef

define Package/reforis-netboot-plugin/description
  reForis Netboot plugin.
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-netboot-plugin,reforis_netboot))
# call BuildPackage <= assures OWR build system that this is package
