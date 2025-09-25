#
# Copyright (C) 2025 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ngsnek
PKG_VERSION:=0.1
PKG_RELEASE:=2025-09-25-01

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/ekalouskova/ngsnek.git
PKG_SOURCE_VERSION:=83340f11522ee46f4e7b423a04eb3273e08e2d1a

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/ngsnek-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release

define Package/ngsnek
  SECTION:=gui
  CATEGORY:=GUI Utilities
  TITLE:=Turris Omnia System NG Event Kontrol Program
  DEPENDS:=$(RUST_ARCH_DEPENDS) +libwayland
  URL:=https://gitlab.nic.cz/ekalouskova/ngsnek/
endef

define Package/ngsnek/description
        Turris Omnia System NG Event Kontrol Program processes events from display server socket and performs bitmap transformation and synchronization
endef

define Package/ngsnek/install
	$(INSTALL_DIR) $(1)/usr/libexec/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/ngsnek $(1)/usr/libexec/ngsnek
endef

#Build/Compile = $(call Build/Compile/Cargo,ngsnek)

$(eval $(call RustBinPackage,ngsnek))
$(eval $(call BuildPackage,ngsnek))
