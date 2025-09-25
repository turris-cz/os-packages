#
# Copyright (C) 2025 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=peacockr
PKG_VERSION:=0.1
PKG_RELEASE:=2025-09-12-02

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/peacockr.git
PKG_SOURCE_VERSION:=4f1bc97f6bda457f7f42bb505de7ee1606c21870

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/peacockr-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release
RUST_PKG_FEATURES:=target-turris

define Package/peacockr
  SECTION:=gui
  CATEGORY:=GUI Applications
  TITLE:=A status monitor and control interface for Turris Omnia NG
  DEPENDS:=$(RUST_ARCH_DEPENDS) +fontconfig +dejavu-fonts-ttf-DejaVuSans +libwayland
  URL:=https://gitlab.nic.cz/turris/peacockr/
endef

define Package/peacockr/description
        A status monitor and control interface to be used in Turris Omnia NG device. Written in Rust using Slint for the user interface.

        More information on https://gitlab.nic.cz/turris/peacockr
endef

define Package/peacockr/conffiles
/etc/config/peacockr
endef

define Package/peacockr/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/peacockr $(1)/usr/bin/peacockr

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/peacockr.init   $(1)/etc/init.d/peacockr

	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_BIN) ./files/peacockr.config $(1)/etc/config/peacockr
endef

#Build/Compile = $(call Build/Compile/Cargo,peacockr)

$(eval $(call RustBinPackage,peacockr))
$(eval $(call BuildPackage,peacockr))
