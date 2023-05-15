#
# Copyright (C) 2019-2020, 2022 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-openvpn_client-module
PKG_VERSION:=0.7.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-openvpn_client-module.git
PKG_MIRROR_HASH:=c453b6d3f61fe50c7a4ddc23b532440ab024535d0e7799ccfb4961f573ff3db5
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-openvpn_client-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller OpenVPN client module
  DEPENDS:= \
    +foris-controller \
    +turris-cagen \
    +openvpn-openssl
endef

define Package/foris-controller-openvpn_client-module/description
  This is a OpenVPN client module for foris-controller.
endef

define ForisControllerModule/foris-controller-openvpn_client-module/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/openvpn_cl.uci $(1)/etc/uci-defaults/50_add-vpn-client-network
	$(INSTALL_DIR) $(1)/etc/hotplug.d/openvpn
	$(INSTALL_BIN) ./files/guest-integration.hotplug $(1)/etc/hotplug.d/openvpn/60_guest-integration
endef

$(eval $(call ForisControllerModule,foris-controller-openvpn_client-module))
# call BuildPackage <= assures OWR build system that this is package
