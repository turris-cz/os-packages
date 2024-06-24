#
# Copyright (C) 2020-2024 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-data-collection-plugin
PKG_VERSION:=1.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-data-collection
PKG_MIRROR_HASH:=27b0fb25f3680834ae4ee005321ede34a0d3feea5b0b78fb87529e16627ff5fe
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
	node/host \
	hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_data_collection

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-data-collection-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis Data Collection plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-data-collection
  DEPENDS:=\
    +reforis \
    +foris-controller-sentinel-module
endef

define Package/reforis-data-collection-plugin/description
  reForis Data Collection plugin
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-data-collection-plugin,reforis_data_collection))
# call BuildPackage <= assures OWR build system that this is package
