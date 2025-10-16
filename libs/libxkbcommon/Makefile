#
## Copyright (C) 2019-2025 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#

include $(TOPDIR)/rules.mk

PKG_NAME       := libxkbcommon
PKG_VERSION    := 1.10.0
PKG_RELEASE    := $(AUTORELEASE)

PKG_BUILD_DIR  := $(BUILD_DIR)/$(PKG_NAME)-xkbcommon-$(PKG_VERSION)
PKG_SOURCE     := xkbcommon-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL := https://github.com/xkbcommon/libxkbcommon/archive
PKG_HASH       := 0427585a4d6ca17c9fc1ac4b539bf303348e9080af70c5ea402503bc370a9631

PKG_MAINTAINER := CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

define Package/libxkbcommon
	SECTION  := libs
	CATEGORY := Libraries
	TITLE    := Keymap handling library for toolkits and window systems
	URL      := https://xkbcommon.org
endef

define Package/libxkbcommon/description
	xkbcommon is a library for handling of keyboard descriptions, including loading them from disk, parsing them and handling their state.
	It's mainly meant for client toolkits, window systems, and other system applications.
endef

MESON_ARGS += \
	-Denable-x11=false \
	-Denable-wayland=false \
	-Denable-xkbregistry=false \
	-Denable-docs=false \
	-Denable-tools=false # maybe enable tools in separate package?

define Package/libxkbcommon/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libxkbcommon.so* $(1)/usr/lib/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libxkbcommon.so* $(1)/usr/lib/
	
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/include/xkbcommon
	$(CP) $(PKG_INSTALL_DIR)/usr/include/xkbcommon/* $(1)/usr/include/xkbcommon/

	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* $(1)/usr/lib/pkgconfig/
endef

$(eval $(call BuildPackage,libxkbcommon))
