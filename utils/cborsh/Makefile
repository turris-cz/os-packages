#
# Copyright (C) 2026 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cborsh
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/ekalouskova/cborsh.git
PKG_MIRROR_HASH:=343f49545ee45cfd4a2d5f44b0bb480b5e222210a484b53572610c0f68e57387
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/cborsh-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release
define Package/cborsh
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=CLI-based CBOR compositing tool
  DEPENDS:=$(RUST_ARCH_DEPENDS)
  URL:=https://gitlab.nic.cz/ekalouskova/cborsh
endef

define Package/cborsh/description
  Compose CBOR documents using command line arguments
endef

define Package/cborsh/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/cborsh $(1)/usr/bin/cborsh
endef

$(eval $(call RustBinPackage,cborsh))
$(eval $(call BuildPackage,cborsh))
