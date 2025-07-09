
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=suricata-bin
PKG_VERSION:=8.0.0
PKG_RELEASE=$(AUTORELEASE)

PKG_SOURCE:=suricata-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.openinfosecfoundation.org/download/
PKG_HASH:=51f36ef492cbee8779d6018e4f18b98a08e677525851251279c1f851654f451f

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_CPE_ID:=cpe:/a:suricata-ids:suricata

PKG_BUILD_DIR:=$(BUILD_DIR)/suricata-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-values.mk

TARGET_CFLAGS += \
        -fcommon

CONFIGURE_ARGS+= \
	--enable-nflog \
	--enable-nfqueue \
	--disable-libmagic \
	--disable-gccprotect \
	--disable-gccmarch-native \
	--disable-python \
	--host=$(RUSTC_TARGET_ARCH) \
	--enable-debug # for more log levels

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
	+libunwind
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
