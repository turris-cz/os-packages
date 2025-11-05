#
# Copyright (C) 2025 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foot
PKG_VERSION:=1.25.0
PKG_RELEASE=$(AUTORELEASE)

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeberg.org/dnkl/foot/archive/
PKG_HASH:=442a42d576ec72dd50f2d3faea8a664230a47bac79dc1eb6e7c9125ee76c130f

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
	DEPENDS:=+fontconfig +libwayland +libxkbcommon +pixman +wayland-protocols
endef

define Package/foot/description
	A fast, lightweight and minimalistic Wayland terminal emulator
endef


MESON_ARGS+= \
	-Dscanner_bin="$(STAGING_DIR_HOSTPKG)/bin/wayland-scanner" \
	-Ddocs=disabled \
	-Dime=false \
	-Dtests=false

# HACK: As we have issues with building Harfbuzz, these are sadly disabled for now
MESON_ARGS+= \
	-Dfcft:grapheme-shaping=disabled \
	-Dfcft:run-shaping=disabled \
	-Dgrapheme-clustering=disabled \

define Package/foot/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/foot $(1)/usr/bin/foot
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/footclient $(1)/usr/bin/footclient

	$(INSTALL_DIR) $(1)/usr/share/terminfo/f
	$(CP) $(PKG_INSTALL_DIR)/usr/share/terminfo/f/foot* $(1)/usr/share/terminfo/f/
endef

$(eval $(call BuildPackage,foot))
