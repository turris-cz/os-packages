#
# Copyright (C) 2024-2025 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-gsm-plugin
PKG_VERSION:=1.2.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-gsm
PKG_MIRROR_HASH:=947696a1a2b8155bec4f429e445f60955606ac5ce6c79361c5cfcb18d8fc519f
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=node/host hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_gsm

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-gsm-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis GSM plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-gsm-plugin
  DEPENDS:=\
    +reforis\
    +foris-controller-lte-module
endef

define Package/reforis-gsm-plugin/description
  reForis GSM plugin allows seamlessly configure your GSM module.
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-gsm-plugin,reforis_gsm))
# call BuildPackage <= assures OWR build system that this is package
