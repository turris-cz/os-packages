#
## Copyright (C) 2016-2022 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=pkglists
PKG_VERSION:=1.14
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/pkglists
  SECTION:=updater
  CATEGORY:=Turris Updater
  TITLE:=Package lists for the updater
  DEPENDS:=+updater-ng +json4lua +libuci-lua
endef

define Package/pkglists/description
  Turris OS provides various optional features. Those can be installed either
  manually as packages or as package list. This provides database of all
  available package lists in Turris OS and updater-ng's config to use it.
endef

define Package/pkglists/install
	$(INSTALL_DIR) $(1)/usr/share/updater/
	m4 \
		$(if $(CONFIG_TARGET_mpc85xx),,-DGO) \
		$(if $(CONFIG_TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia),-DOMNIA,) \
		./files/definitions.json > $(1)/usr/share/updater/pkglists.json
	$(INSTALL_DATA) ./files/labels.json $(1)/usr/share/updater/pkglists-labels.json

	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/updater/conf.d
	$(INSTALL_CONF) ./files/pkglists.uci $(1)/etc/config/pkglists
	$(INSTALL_DATA) ./files/updater.lua $(1)/etc/updater/conf.d/turris-pkglists.lua
endef

define Package/pkglists/conffiles
/etc/config/pkglists
endef

Build/Compile:=:

define Package/pkglists/postinst
if [ -n "$$IPKG_INSTROOT" ] &&  [ -n "$$BOOTSTRAP_PKGLISTS" ]; then
	mkdir -p "$$IPKG_INSTROOT/usr/share/updater"
	echo "$$BOOTSTRAP_PKGLISTS" \
		> "$$IPKG_INSTROOT/usr/share/updater/bootstrap-pkglists"
fi
endef

$(eval $(call BuildPackage,pkglists))
