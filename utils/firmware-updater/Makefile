#
## Copyright (C) 2023 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=firmware-updater
PKG_VERSION:=1.2
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/firmware-updater
  TITLE:=Tool to update firmwares in Turris routers
endef

define Package/firmware-updater/description
  Script that makes sure you have the latest U-Boot, rescue system and MCU firmware if applicable.
  Apart from that updates factory image whenever new major version comes out.
endef

define Package/firmware-updater/install
	$(INSTALL_DIR) $(1)/etc/updater/hook_postupdate
	$(INSTALL_BIN) ./files/firmware-updater.sh $(1)/etc/updater/hook_postupdate/96_firmware_updater
endef

Build/Compile:=:

define Package/firmware-updater/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	/etc/updater/hook_postupdate/96_firmware_updater
}
endef

$(eval $(call BuildPackage,firmware-updater))
