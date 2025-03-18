#
# Copyright (C) 2025 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sshoxy-haas
PKG_VERSION:=0.2.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/turris-cz/sshoxy/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=f7cbdf9611c192c1c7be3a45e9638e52274dee37b187d454e090b99516d02800

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/sshoxy-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

## Most optimized profile
CARGO_PKG_PROFILE:=release-lto

define Package/sshoxy-haas
  SECTION:=net
  CATEGORY:=Network
  TITLE:=sshoxy SSH proxy for HAAS project
  DEPENDS:=$(RUST_ARCH_DEPENDS) +libopenssl
  URL:=https://github.com/turris-cz/sshoxy/
endef

define Package/sshoxy-haas/description
	HaaS proxy is tool for redirectiong SSH session from local computer to server of HaaS with additional information.

	More information on https://haas.nic.cz
endef


define Package/sshoxy-haas/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/haas-proxy $(1)/usr/bin/sshoxy-haas

	$(INSTALL_DIR) $(1)/usr/libexec/
	$(INSTALL_BIN) ./files/sshoxy-haas-login-handler.sh $(1)/usr/libexec/sshoxy-haas-login-handler.sh

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/sshoxy-haas.init $(1)/etc/init.d/sshoxy-haas

endef

Build/Compile = $(call Build/Compile/Cargo,sshoxy-haas)

$(eval $(call RustBinPackage,sshoxy-haas))
$(eval $(call BuildPackage,sshoxy-haas))
