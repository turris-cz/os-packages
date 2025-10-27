
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=suricata-bin
PKG_VERSION:=8.0.1
PKG_RELEASE=$(AUTORELEASE)

PKG_SOURCE:=suricata-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.openinfosecfoundation.org/download/
PKG_HASH:=bd868f41717e5431cdda3a99386810257aafdbe2dbcbb58d07fb8476a03358a5

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_CPE_ID:=cpe:/a:suricata-ids:suricata

PKG_BUILD_DIR:=$(BUILD_DIR)/suricata-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_PARALLEL:=1
PKG_SSP:=0

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-values.mk

CONFIGURE_ARGS+= \
	--enable-nflog \
	--enable-nfqueue \
	--disable-libmagic \
	--disable-gccprotect \
	--disable-gccmarch-native \
	--disable-python \
	--host=$(RUSTC_TARGET_ARCH) \
	--enable-debug # for more log levels

# Disable stack protector to avoid __stack_chk_fail_local errors on musl/PowerPC
# This is needed because Rust's cc crate compiles vendored C code (like libz-sys)
# with stack protection enabled by default, which doesn't work with musl on 32-bit arches
TARGET_CFLAGS+=-fno-stack-protector

define Package/suricata-bin
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Network IDS, IPS and NSM engine
  URL:=https://suricata-ids.org/
  DEPENDS:= \
	+libpcre2 \
	+libyaml \
	+jansson \
	+libmagic \
	+libpthread \
	+librt \
	+libpcap \
	+libcap-ng \
	$(LUAJIT_DEP) \
	+libnetfilter-queue \
	+iptables-mod-nfqueue \
	+libnetfilter-log \
	+libnfnetlink \
	+iptables-mod-conntrack-extra \
	+libnet-1.2.x \
	+nspr \
	+libnss \
	+liblz4 \
	+PACKAGE_libunwind:libunwind
endef

define Package/suricata-rules
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Rules files for Suricata
  URL:=https://suricata-ids.org/
  DEPENDS:=+suricata-bin
endef

define Package/suricata-bin/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/suricata* $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/suricata
	$(CP) $(PKG_BUILD_DIR)/suricata.yaml $(1)/etc/suricata
	$(CP) $(PKG_BUILD_DIR)/etc/classification.config $(1)/etc/suricata
	$(CP) $(PKG_BUILD_DIR)/etc/reference.config $(1)/etc/suricata
	$(CP) $(PKG_BUILD_DIR)/threshold.config $(1)/etc/suricata
endef

define Package/suricata-rules/install
	$(INSTALL_DIR) $(1)/etc/suricata/rules
	$(CP) $(PKG_BUILD_DIR)/rules/*.rules $(1)/etc/suricata/rules
endef

$(eval $(call BuildPackage,suricata-bin))
$(eval $(call BuildPackage,suricata-rules))
