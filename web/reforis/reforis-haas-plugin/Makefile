#
# Copyright (C) 2020-2022 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-haas-plugin
PKG_VERSION:=0.1.4
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-haas
PKG_MIRROR_HASH:=95a619f32c1c0bdf3ab9697907a41d917858cf299df9bed26075890814a8ade5
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
	node/host \
	reforis-distutils/host \

PYTHON3_PKG_FORCE_DISTUTILS_SETUP:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-haas-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis HaaS plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-haas
  DEPENDS:=\
    +reforis \
    +reforis-data-collection-plugin \
    +foris-controller-haas-module
endef

define Package/reforis-haas-plugin/description
  reForis Honeypot as a Service plugin
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-haas-plugin,reforis_haas))
# call BuildPackage <= assures OWR build system that this is package
