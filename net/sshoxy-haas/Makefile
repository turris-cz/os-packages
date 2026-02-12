#
# Copyright (C) 2026 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sshoxy-haas
PKG_VERSION:=0.2.3
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/turris-cz/sshoxy/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=f9bd54a7171b81c2b0915410b201d475089f704f41a9dd7f57342897b9307051

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/sshoxy-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release

define Package/sshoxy-haas
  SECTION:=net
  CATEGORY:=Network
  TITLE:=sshoxy SSH proxy for HAAS project
  DEPENDS:=$(RUST_ARCH_DEPENDS) +libopenssl +reforis-haas-plugin
  CONFLICTS:=haas-proxy
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

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/haas.uci $(1)/etc/config/haas
	
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-haas-proxy

	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/sentinel-firewall.sh $(1)/usr/libexec/sentinel/firewall.d/80-haas-proxy.sh

endef

Build/Compile = $(call Build/Compile/Cargo,sshoxy-haas)

$(eval $(call RustBinPackage,sshoxy-haas))
$(eval $(call BuildPackage,sshoxy-haas))
