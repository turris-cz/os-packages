#
# Copyright (C) 2016-2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=omnia-mcutool
PKG_VERSION:=0.3-rc3
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/omnia-mcutool/-/archive/$(PKG_VERSION)/
PKG_HASH:=80bc6a01ab86d51ebfdbddf77d74eead999a9bf7dbd08ca1fd4e8e1910eaf192

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-2.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/omnia-mcutool
  TITLE:=Tool to manage MCU on Turris Omnia
  DEPENDS:=+omnia-mcu-firmware +libopenssl @TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia
endef

define Package/omnia-mcutool/description
  This package contains omnia-mcutool, the utility for accessing the MCU on the
  Turris Omnia router. Its main purpose is to upgrade new MCU firmware. It can
  also be used to print MCU firmware version and access other MCU settings.
  On boards where board information and cryptography is provided by the MCU it
  also supports accessing this functionality.
endef

TARGET_LDFLAGS += -lcrypto

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -Wall" \
		LDFLAGS="$(TARGET_LDFLAGS) -lssl -lcrypto" \
		MCUTOOL_VERSION="$(PKG_VERSION)"
endef

define Package/omnia-mcutool/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omnia-mcutool $(1)/usr/bin/
endef

$(eval $(call BuildPackage,omnia-mcutool))
