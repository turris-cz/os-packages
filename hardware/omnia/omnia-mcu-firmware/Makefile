#
# Copyright (C) 2023-2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=omnia-mcu-firmware
PKG_DISTNAME:=omnia_hw_ctrl
PKG_VERSION:=4.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_SUBDIR:=$(PKG_DISTNAME)-binaries-v$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.bz2
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/hw/$(PKG_DISTNAME)/-/releases/v$(PKG_VERSION)/downloads/
PKG_HASH:=9c6a3d88ae2ca093dd35aace040f0b1eb1cb5c1141575b45623bdd64d733c59f

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

include $(INCLUDE_DIR)/package.mk

define Package/omnia-mcu-firmware
  TITLE:=Firmware for MCU in Turris Omnia
  DEPENDS:=@TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia
endef

define Package/omnia-mcu-firmware/description
  This package contains firmware binaries for the microcontroller on the Turris
  Omnia router. The binaries are used by the omnia-mcutool utility when
  upgrading MCU firmware.
endef

define Build/Compile
	true
endef

define Package/omnia-mcu-firmware/install
	$(INSTALL_DIR) $(1)/usr/share/omnia-mcu-firmware/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/*.bin $(1)/usr/share/omnia-mcu-firmware/
endef

$(eval $(call BuildPackage,omnia-mcu-firmware))
