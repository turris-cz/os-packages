#
# Copyright (C) 2025 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foot
PKG_VERSION:=1.24.0
PKG_RELEASE=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeberg.org/dnkl/foot/archive/
PKG_HASH:=???

PKG_MAINTAINER:= CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

define Package/foot
  SECTION:=gui
  CATEGORY:=GUI Applications
  TITLE:=Foot
  URL:=https://codeberg.org/dnkl/foot
  DEPENDS:=+libwayland +pixman
endef

define Package/foot/description
  A fast, lightweight and minimalistic Wayland terminal emulator
endef

MESON_ARGS+= \
  -Ddocs=disabled \
  -Dgrapheme-clustering=disabled \
  -Dime=disabled \
  -Dtests=disabled

define Package/foot/install
  $(INSTALL_DIR) $(1)/usr/bin
  $(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/foot $(1)/usr/bin/foot
  $(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/foot-client $(1)/usr/bin/foot-client

  $(INSTALL_DIR) $(1)/usr/share/terminfo/f
  $(CP) $(PKG_INSTALL_DIR)/usr/share/terminfo/f/foot* $(1)/usr/share/terminfo/f/
endef
