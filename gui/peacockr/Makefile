#
# Copyright (C) 2025 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=peacockr
PKG_VERSION:=0.3.0
PKG_RELEASE:=2026-02-25-01

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/peacockr.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/peacockr-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

LOCALES:=cs

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release-opt

define Package/peacockr
  SECTION:=gui
  CATEGORY:=GUI Applications
  TITLE:=A status monitor and control interface for Turris Omnia NG
  DEPENDS:=$(RUST_ARCH_DEPENDS) +fontconfig +dejavu-fonts-ttf-DejaVuSans +libwayland +xkeyboard-config +peacomp +ngsnek +foot
  URL:=https://gitlab.nic.cz/turris/peacockr/
endef

define Package/peacockr/description
        A status monitor and control interface to be used in Turris Omnia NG device. Written in Rust using Slint for the user interface.

        More information on https://gitlab.nic.cz/turris/peacockr
endef

define Package/peacockr/conffiles
/etc/peacockr/config.kdl
endef

define Package/peacockr/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/peacockr-frontend $(1)/usr/bin/peacockr

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/peacockr.init $(1)/etc/init.d/peacockr

  $(INSTALL_DIR) $(1)/etc/peacockr/
  $(INSTALL_CONF) $(PKG_BUILD_DIR)/frontend/resources/config.kdl $(1)/etc/peacockr/config.kdl
endef

define Build/Compile
  pushd $(PKG_BUILD_DIR)
  cargo build --verbose \
    --package peacockr-frontend \
    --profile $(CARGO_PKG_PROFILE) \
    $(if $(strip $(RUST_PKG_FEATURES)),--features "$(strip $(RUST_PKG_FEATURES))") \
    $(if $(filter --jobserver%,$(PKG_JOBS)),,-j1) \
    $(CARGO_PKG_ARGS)

  ./build-aux/compile-locales.sh
endef

# $(1): name of the package
# $(2): translation name
define TRANSLATION

define Package/$(1)-l10n-$(2)
  TITLE:=Translation for package $(1): $(2)
  DEPENDS:=+$(1) +gettext-tools
endef

define Package/$(1)-l10n-$(2)/install
  $(INSTALL_DIR) $(1)/usr/share/locales/cs/LC_MESSAGES/
	$(INSTALL_DATA) \
    $(PKG_BUILD_DIR)/target/locales/cs/LC_MESSAGES/peacockr-frontend.mo \
    $(1)/usr/share/locales/cs/LC_MESSAGES/peacockr-frontend.mo
endef

$$(eval $$(call BuildPackage,$(1)-l10n-$(2)))

$(eval $(call BuildPackage,peacockr))
