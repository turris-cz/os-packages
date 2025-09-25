#
# Copyright (C) 2025 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=peacomp
PKG_VERSION:=0.1
PKG_RELEASE:=2025-09-12-03

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/ekalouskova/peacomp.git
PKG_SOURCE_VERSION:=f9ad755e517a7d77c2ea65cd1d09277329845ead

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/peacomp-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release

define Package/peacomp
  SECTION:=gui
  CATEGORY:=Wayland Compositors
  TITLE:=Minimal Wayland compositor for Turris Omnia NG
  DEPENDS:=$(RUST_ARCH_DEPENDS) +libxkbcommon +libinput +pixman
  URL:=https://gitlab.nic.cz/ekalouskova/peacomp
endef

define Package/peacomp/description
        Minimal Wayland compositor for Turris Omnia NG with DRM+LibInput+UDev backend and Pixman software rendering

        More information on https://gitlab.nic.cz/ekalouskova/peacomp
endef

define Package/peacomp/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/peacomp $(1)/usr/bin/peacomp

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/peacomp.init   $(1)/etc/init.d/peacomp

	$(INSTALL_DIR) $(1)/etc/profile.d/
	$(INSTALL_BIN) ./files/peacomp-wayland-display.sh $(1)/etc/profile.d/peacomp-wayland-display.sh
endef

#Build/Compile = $(call Build/Compile/Cargo,peacomp)

$(eval $(call RustBinPackage,peacomp))
$(eval $(call BuildPackage,peacomp))
