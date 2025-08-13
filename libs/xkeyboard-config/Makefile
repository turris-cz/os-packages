#
# Copyright (C) 2019-2025 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
#

include $(TOPDIR)/rules.mk

PKG_NAME    := xkeyboard-config
PKG_VERSION := 2.45
PKG_RELEASE := $(AUTORELEASE)

PKG_SOURCE_PROTO   := git
PKG_SOURCE_URL     := https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git
PKG_SOURCE_VERSION := a8b1be93168cbd3246359c724f090e821079b313
PKG_MIRROR_HASH    := a8b1be93168cbd3246359c724f090e821079b313

PKG_MAINTAINER    := CZ.NIC <packaging@turris.cz>
PKG_LICENSE       := GPL-3.0-or-later
PKG_LICENSE_FILES := COPYING

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

define Package/xkeyboard-config
	SECTION  := libs
	CATEGORY := Libraries
	TITLE    := XKB keyboard configuration data
	URL      := https://https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config
endef

define Package/xkeyboard-config/description
	This project provides a consistent, well-structured, frequently
	released, open source database of keyboard configuration data.
	The project is targeted at XKB-based systems.
endef

define Package/xkeyboard-config/install
	$(INSTALL_DIR) $(1)/usr/share
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/compat
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/geometry
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/geometry/digital_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/geometry/sgi_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/keycodes
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/keycodes/digital_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/keycodes/sgi_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/types
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/digital_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/fujitsu_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/hp_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/jolla_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/macintosh_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/nec_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/sgi_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/sharp_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/sony_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/sun_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/symbols/xfree68_vndr
	$(INSTALL_DIR) $(1)/usr/share/xkeyboard-config-2/rules
	$(INSTALL_DIR) $(1)/usr/share/X11

	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/*                        $(1)/usr/share/xkeyboard-config-2/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/compat/*                 $(1)/usr/share/xkeyboard-config-2/compat/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/geometry/*               $(1)/usr/share/xkeyboard-config-2/geometry/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/geometry/digital_vndr/*  $(1)/usr/share/xkeyboard-config-2/geometry/digital_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/geometry/sgi_vndr/*      $(1)/usr/share/xkeyboard-config-2/geometry/sgi_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/keycodes/*               $(1)/usr/share/xkeyboard-config-2/keycodes/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/keycodes/digital_vndr/*  $(1)/usr/share/xkeyboard-config-2/keycodes/digital_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/keycodes/sgi_vndr/*      $(1)/usr/share/xkeyboard-config-2/keycodes/sgi_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/types/*                  $(1)/usr/share/xkeyboard-config-2/types/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/*                $(1)/usr/share/xkeyboard-config-2/symbols/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/digital_vndr/*   $(1)/usr/share/xkeyboard-config-2/symbols/digital_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/fujitsu_vndr/*   $(1)/usr/share/xkeyboard-config-2/symbols/fujitsu_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/hp_vndr/*        $(1)/usr/share/xkeyboard-config-2/symbols/hp_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/jolla_vndr/*     $(1)/usr/share/xkeyboard-config-2/symbols/jolla_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/macintosh_vndr/* $(1)/usr/share/xkeyboard-config-2/symbols/macintosh_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/nec_vndr/*       $(1)/usr/share/xkeyboard-config-2/symbols/nec_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/sgi_vndr/*       $(1)/usr/share/xkeyboard-config-2/symbols/sgi_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/sharp_vndr/*     $(1)/usr/share/xkeyboard-config-2/symbols/sharp_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/sony_vndr/*      $(1)/usr/share/xkeyboard-config-2/symbols/sony_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/sun_vndr/*       $(1)/usr/share/xkeyboard-config-2/symbols/sun_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/symbols/xfree68_vndr/*   $(1)/usr/share/xkeyboard-config-2/symbols/xfree68_vndr/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/xkeyboard-config-2/rules/*                  $(1)/usr/share/xkeyboard-config-2/rules/
	$(CP) $(PKG_INSTALL_DIR)/usr/share/X11/*                                       $(1)/usr/share/X11/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/share/pkgconfig/* /usr/lib/pkgconfig/
endef

$(eval $(call BuildPackage,xkeyboard-config))
