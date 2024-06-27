#
# Copyright (C) 2018-2020 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel-dynfw-c-client
PKG_VERSION:=1.2.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.com/miska/dynfw-c.git
PKG_MIRROR_HASH:=4f04411f82aa42f0d8b3990a690bc73db1a4c36b7350d0d5ba4ea263da5ce1d0
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING.txt

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/sentinel-dynfw-c-client/Default
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=DynFW client written in C
  DEPENDS:=+czmq +msgpack-c +sentinel-dynfw-cert
endef

define Package/sentinel-dynfw-c-client-iptables
$(call Package/sentinel-dynfw-c-client/Default)
  TITLE+= - iptables
  DEPENDS+=+firewall +libdynfw +ipset +iptables +sentinel-firewall-iptables
  CONFLICTS:=sentinel-dynfw-client
endef

define Package/sentinel-dynfw-c-client-nftables
$(call Package/sentinel-dynfw-c-client/Default)
  TITLE+= - nftables
  DEPENDS+=+libdynfw +firewall4 +sentinel-firewall-nftables
  CONFLICTS:=sentinel-dynfw-client
endef

define Package/libdynfw
$(call Package/sentinel-dynfw-c-client/Default)
  TITLE+= - shared library
endef

define Package/sentinel-dynfw-c-client-snapshoter
$(call Package/sentinel-dynfw-c-client/Default)
  TITLE+= - snapshoter
  DEPENDS+= +libdynfw
endef

define Package/sentinel-dynfw-c-client/description/Default
  Sentinel dynamic firewall client. Keeps a list blacklisted IPs up to date in realtime.
endef

define Package/sentinel-dynfw-c-client-iptables/description
  $(call Package/sentinel-dynfw-c-client/description/Default)

  This package takes care of integration into iptables based OpenWrt firewall.
endef

define Package/sentinel-dynfw-c-client-nftables/description
  $(call Package/sentinel-dynfw-c-client/description/Default)

  This package takes care of integration into nftables based firewall.
endef

define Package/libdynfw/description
  $(call Package/sentinel-dynfw-c-client/description/Default)

  This is a shared library used by all subpackages.
endef

define Package/sentinel-dynfw-c-client-snapshoter/description
  $(call Package/sentinel-dynfw-c-client/description/Default)

  This package allows you to dump the list of blocked IP addresses.
endef

define Build/Compile
	$(call Build/Compile/Default)
	$(MAKE) -C $(PKG_BUILD_DIR) install DESTDIR=$(PKG_BUILD_DIR)/install
endef

define Package/libdynfw/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/install/usr/lib*/libdynfw.so.1.0.0 $(1)/usr/lib
	cd $(1)/usr/lib && \
		$(LN) libdynfw.so.1.0.0 libdynfw.so.1 && \
		$(LN) libdynfw.so.1.0.0 libdynfw.so.1.0
endef

define Package/sentinel-dynfw-c-client-snapshoter/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/install/usr/bin/dynfw-snapshoter $(1)/usr/bin
endef

define Package/sentinel-dynfw-c-client-nftables/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/install/usr/bin/dynfw-nfset-client $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/init.nftables $(1)/etc/init.d/sentinel-dynfw-client
endef

define Package/sentinel-dynfw-c-client-iptables/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/install/usr/bin/dynfw-ipset-client $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/init.iptables $(1)/etc/init.d/sentinel-dynfw-client
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-sentinel-dynfw-client
	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/sentinel-firewall.sh $(1)/usr/libexec/sentinel/firewall.d/50-dynfw.sh
	$(INSTALL_DATA) ./files/sentinel-firewall-utils.sh $(1)/usr/libexec/sentinel/firewall.d/dynfw-utils.sh
endef

$(eval $(call BuildPackage,libdynfw))
$(eval $(call BuildPackage,sentinel-dynfw-c-client-iptables))
$(eval $(call BuildPackage,sentinel-dynfw-c-client-nftables))
$(eval $(call BuildPackage,sentinel-dynfw-c-client-snapshoter))
