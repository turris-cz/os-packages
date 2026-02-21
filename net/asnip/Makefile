#
# Copyright (C) 2026 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=asnip
PKG_VERSION:=0.2.2
PKG_RELEASE:=2026-02-21

PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeberg.org/1millibyte/asnip/archive/
PKG_MIRROR_HASH:=5a17ab0c2c2cdcb4f9941f24b4129dd78899db69cbe3b269b3b762ded45b572a

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=EUPL-1.2
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_RELEASE)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release

define Package/asnip
  SECTION:=net
  CATEGORY:=Network
  TITLE:=AAAA SNI Proxy
  DEPENDS:=$(RUST_ARCH_DEPENDS)
  URL:=https://codeberg.org/1millibyte/asnip
endef

define Package/asnip/description
  Simple TLS/TCP proxy and NAT removing the need for HTTP proxies and dual-stack for your service.
endef

define Package/asnip/install
  $(INSTALL_DIR) $(1)/usr/bin/
  $(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/asnip $(1)/usr/bin/asnip

  $(INSTALL_DIR) $(1)/usr/share/doc/asnip/
  $(CP) $(PKG_BUILD_DIR)/resources/example-config.toml $(1)/usr/share/doc/asnip/example-config.toml

  $(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/asnip.init $(1)/etc/init.d/asnip

  $(INSTALL_DIR) $(1)/etc/asnip/
endef

$(eval $(call RustBinPackage,asnip))
$(eval $(call BuildPackage,asnip))
