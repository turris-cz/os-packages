#
# Copyright (C) 2026 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-auth-rs
PKG_VERSION:=0.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/turris-auth-rs.git
PKG_HASH:=32dabf6d1807791b576d4da2b1c1c7ceacf41773
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/turris-auth-rs-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release

define Package/turris-auth-rs
  SECTION:=web
  CATEGORY:=Web
  TITLE:=Turris Authentication (Rust)
  DEPENDS:=\
    $(RUST_ARCH_DEPENDS) \
    +lighttpd-mod-fastcgi \
    +lighttpd-mod-alias \
    +turris-bootstrap-theme \
    +rpcd \
    +ubus \
    +uci
  CONFLICTS:=turris-auth
  URL:=https://gitlab.nic.cz/turris/reforis/turris-auth-rs/
endef

define Package/turris-auth-rs/description
  Turris Authentication for web applications. This is login gateway that can be
  optionally added to any web application.
endef


define Package/sshoxy-haas/install
    $(INSTALL_DIR) $(1)/usr/bin/
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/turris-auth-rs $(1)/usr/bin/turris-auth-rs

    $(INSTALL_DIR) $(1)/usr/share/turris-auth-rs/templates/
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/templates/* $(1)/usr/share/turris-auth-rs/templates/

    $(INSTALL_DIR) $(1)/usr/share/turris-auth-rs/locales/
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/locales/en/main.ftl $(1)/usr/share/turris-auth-rs/locales/

    $(INSTALL_DIR) $(1)/etc/lighttpd/conf.d
    $(INSTALL_BIN) ./files/lighttpd.conf $(1)/etc/lighttpd/conf.d/50-turris-auth-rs.conf

endef

Build/Compile = $(call Build/Compile/Cargo,turris-auth-rs)

$(eval $(call RustBinPackage,turris-auth-rs))
$(eval $(call BuildPackage,turris-auth-rs))

# Prepare translations
TURRIS_AUTH_RS_TRANSLATIONS:=cs de es fr la nb nl pl ru sk sv

# $1 = translation name
define TurrisAuthRsTranslation
 define Package/turris-auth-rs-l10n-$(1)
   SECTION:=web
   CATEGORY:=Web
   SUBMENU:=reForis
   TITLE:=turris-auth-rs-l10n-$(1)
   DEPENDS:=+turris-auth-rs
   MAINTAINER:=CZ.NIC <packaging@turris.cz>
 endef

 define Package/turris-auth-rs-l10n-$(1)/install
    $$(INSTALL_DIR) $$(1)/usr/share/turris-auth-rs/locales/$(1)
    $$(CP) $$(PKG_BUILD_DIR)/locales/$(1)/main.ftl $$(1)/usr/share/turris-auth-rs/locales/$(1)
 endef

 define Package/reforis-l10n-$(1)/postrm
#!/bin/sh
[ -n "$$$${IPKG_INSTROOT}" ] || /etc/init.d/lighttpd restart
 endef

 define Package/reforis-l10n-$(1)/postinst
#!/bin/sh
[ -n "$$$${IPKG_INSTROOT}" ] || /etc/init.d/lighttpd restart
 endef

 $$(eval $$(call BuildPackage,turris-auth-rs-l10n-$(1)))
endef

 $(foreach trans,$(TURRIS_AUTH_RS_TRANSLATIONS),$(eval$(call TurrisAuthRsTranslation,$(trans))))
