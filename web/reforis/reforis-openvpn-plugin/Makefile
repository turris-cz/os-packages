#
# Copyright (C) 2019-2024 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-openvpn-plugin
PKG_VERSION:=2.2.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-openvpn
PKG_MIRROR_HASH:=5de548dec875aeda3c3e3961e21d63d773cdc8c895031abf62823385e5a2df1d
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=\
	node/host \
	hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_openvpn

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-openvpn-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis OpenVPN plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-openvpn
  DEPENDS:= \
    +reforis \
    +foris-controller-openvpn-module \
    +foris-controller-openvpn_client-module
endef

define Package/reforis-openvpn-plugin/description
  Reforis OpenVPN plugin.
endef

define ReForisPlugin/reforis-openvpn-plugin/install
	$(INSTALL_DIR) $(1)/usr/share/foris/external-links
	$(INSTALL_DATA) ./files/openvpn_client-external-redirect.csv $(1)/usr/share/foris/external-links/
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-openvpn-plugin,reforis_openvpn))
# call BuildPackage <= assures OWR build system that this is package
