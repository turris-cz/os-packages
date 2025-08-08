#
## Copyright (C) 2022 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

PKG_NAME           := peacockr
PKG_VERSION        := 0.1.0
PKG_RELEASE        := $(AUTORELEASE)

PKG_SOURCE         := 
PKG_SOURCE_URL     :=
PKG_HASH           :=

PKG_MAINTAINER     := CZ.NIC <packaging@turris.cz>
PKG_LICENSE        := GPL-3.0-or-later
PKG_LICENSE_FILES  := LICENSE.txt

PKG_BUILD_DEPENDS  := rust/host
PKG_BUILD_DIR      := $(BUILD_DIR)/peacockr-$(PKG_VERSION)
PKG_BUILD_PARALLEL := 1

CARGO_PKG_PROFILE  := release

define Package/peacockr
	TITLE   := peacockr
	DEPENDS := +libxkbcommon +libinput
	URL     := https://gitlab.nic.cz/turris/peacockr
endef

define Package/peacockr/description
	A display controller to be used in Turris NG device.
	Written in Rust using Slint for the user interface.
endef

define Package/peacockr/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/peacockr $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/peacockr.init $(1)/etc/init.d/peacockr
endef

Build/Compile = $(call Build/Compile/Cargo,peacockr)

$(eval $(call RustBinPackage,peacockr))
$(eval $(call BuildPackage,peacockr))
