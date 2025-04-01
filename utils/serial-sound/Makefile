#
## Copyright (C) 2025 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=serial-sound
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_LICENSE:=GPL-3.0-or-later
PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/serial-sound
  TITLE:=Play sounds over the serial port
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) -o $(PKG_BUILD_DIR)/serial-sound $(PKG_BUILD_DIR)/serial-sound.c
endef

define Package/serial-sound/description
 Contains a simple program that allows you to use your serial port as audio out.
endef

define Package/serial-sound/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/serial-sound $(1)/usr/bin/serial-sound
endef

$(eval $(call BuildPackage,serial-sound))
