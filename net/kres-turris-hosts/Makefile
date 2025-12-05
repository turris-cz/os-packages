#
# Copyright (C) 2025 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kres-turris-hosts
PKG_VERSION:=0.1
PKG_RELEASE:=2025-12-03-01

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/ekalouskova/kres-turris-hosts.git
PKG_SOURCE_VERSION:=571785fc9707533851dac9cc8f66c6e25a69312f

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/kres-turris-hosts-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release

define Package/kres-turris-hosts
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Module for Knot Resolver to gather DHCP leases on U-Bus
	DEPENDS:=$(RUST_ARCH_DEPENDS) +knot-resolver
endef

define Package/kres-turris-hosts/description
	Module for Knot Resolver to gather DHCP leases on U-Bus
endef

define Package/kres-turris-hosts/install
	$(INSTALL_DIR) $(1)/usr/lib/knot-resolver/kres_modules
	$(CP) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/libturris_hosts.so $(1)/usr/lib/knot-resolver/kres_modules/turris_hosts.so

	$(INSTALL_DIR) $(1)/usr/share/acl.d
	$(CP) ./files/acl.json /usr/share/acl.d/kres-turris-hosts.json
endef

define Build/Compile
	+$(CARGO_PKG_VARS) \
	BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$(TOOLCHAIN_DIR) -I$(STAGING_DIR)/usr/include" \
	cargo build -v \
		--profile $(CARGO_PKG_PROFILE) \
		--manifest-path $(PKG_BUILD_DIR)/Cargo.toml \
		--target $(RUSTC_TARGET_ARCH) \
		$(if $(strip $(RUST_PKG_FEATURES)),--features "$(strip $(RUST_PKG_FEATURES))") \
		$(if $(filter --jobserver%,$(PKG_JOBS)),,-j1) \
		$(CARGO_PKG_ARGS) \
		$(2)
endef

$(eval $(call BuildPackage,kres-turris-hosts))
