#
# Copyright (C) 2015-2025 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sshoxy-haas
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/turris-cz/sshoxy/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=5c17971b3b23f51618c845fc2548e79493ee4fa6cb3b5d21bfe44a6985994750

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include ../../lang/rust/rust-package.mk

## Most optimized profile
CARGO_PKG_PROFILE:=release-lto

define Package/sshoxy-haas
  SECTION:=net
  CATEGORY:=Network
  TITLE:=sshoxy SSH proxy for HAAS project
  DEPENDS:=$(RUST_ARCH_DEPENDS)
  URL:=https://github.com/turris-cz/sshoxy/
endef

define Package/ripgrep/description
	HaaS proxy is tool for redirectiong SSH session from local computer to server of HaaS with additional information.

	More information on https://haas.nic.cz
endef

Build/Compile = $(call Build/Compile/Cargo,sshoxy-haas)

$(eval $(call RustBinPackage,sshoxy-haas))
$(eval $(call BuildPackage,sshoxy-haas))
