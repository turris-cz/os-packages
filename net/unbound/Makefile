#
# Copyright (C) 2010-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=unbound
PKG_VERSION:=1.19.3
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://nlnetlabs.nl/downloads/unbound/
PKG_HASH:=3ae322be7dc2f831603e4b0391435533ad5861c2322e34a76006a9fb65eb56b9

PKG_BUILD_PARALLEL:=1
PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/unbound/Default
  TITLE:=A validating, recursive & caching DNS resolver
  URL:=https://nlnetlabs.nl/projects/unbound/about/
  DEPENDS:=+libldns +libopenssl +dnssec-rootkey +resolver-conf
  PROVIDES:=dns-resolver
endef

define Package/unbound
  $(call Package/unbound/Default)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE+= (daemon)
  USERID:=unbound=553:unbound=553
  DEPENDS+= +libunbound +cert-backup
endef

define Package/unbound/description
  This package contains the Unbound daemon.
endef

define Package/unbound-anchor
  $(call Package/unbound/Default)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE+= (anchor utility)
  DEPENDS+= +unbound +libexpat
endef

define Package/unbound-anchor/description
  This package contains the Unbound anchor utility.
endef

define Package/unbound-control-setup
  $(call Package/unbound/Default)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE+= (control setup utility)
  DEPENDS+= +unbound +openssl-util
endef

define Package/unbound-control-setup/description
  This package contains the Unbound control setup utility.
endef

define Package/unbound-host
  $(call Package/unbound/Default)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE+= (DNS lookup utility)
  DEPENDS+= +libunbound
endef

define Package/unbound-host/description
  This package contains the Unbound DNS lookup utility.
endef

define Package/libunbound
  $(call Package/unbound/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE+= (library)
  DEPENDS+= +libevent2 +libpthread +libmnl
endef

define Package/libunbound/description
  This package contains the Unbound shared library.
endef

CONFIGURE_ARGS += \
	--disable-dsa \
	--disable-gost \
	--enable-allsymbols \
	--enable-subnet \
	--with-libexpat="$(STAGING_DIR)/usr" \
	--with-ssl="$(STAGING_DIR)/usr" \
	--enable-event-api \
	--with-libevent="$(STAGING_DIR)/usr" \
	--enable-ipset \
	--with-libmnl="$(STAGING_DIR)/usr" \
	--with-pthreads

# uClibc doesn't support TCP fast open -> --enable-tfo-{client,server} would fail
ifneq ($(CONFIG_USE_UCLIBC),y)
CONFIGURE_ARGS += \
	--enable-tfo-server \
	--enable-tfo-client
endif

define Package/unbound/conffiles
/etc/unbound/unbound.conf
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/libunbound.{so*,a,la} $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/include/unbound.h $(1)/usr/include/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/include/unbound-event.h $(1)/usr/include/
endef

define Package/unbound/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/sbin/unbound \
		$(PKG_INSTALL_DIR)/usr/sbin/unbound-checkconf \
		$(1)/usr/sbin/

	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/unbound-control $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/unbound
	$(INSTALL_CONF) ./files/named.cache $(1)/etc/unbound/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/unbound-init $(1)/etc/init.d/unbound
	$(INSTALL_DIR) $(1)/usr/share/unbound/
	$(INSTALL_BIN) ./files/unbound.postinst $(1)/usr/share/unbound/postinst
	$(LN) /var/etc/unbound/unbound.conf $(1)/etc/unbound/unbound.conf
endef

define Package/unbound/postinst
#!/bin/sh
set -ex
[ -n "$$IPKG_INSTROOT" ] || {
/usr/share/unbound/postinst
}
endef

define Package/unbound/prerm
#!/bin/sh
set -ex
if [ -z "$$IPKG_INSTROOT" ]; then
/etc/init.d/unbound disable
/etc/init.d/unbound stop
uci set resolver.common.prefered_resolver="kresd"
uci commit
fi
endef

define Package/unbound/postrm
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
[ \! -x /etc/init.d/resolver ] || /etc/init.d/resolver restart
fi
endef

define Package/unbound-anchor/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/unbound-anchor $(1)/usr/sbin/
endef

define Package/unbound-control-setup/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/unbound-control-setup $(1)/usr/sbin/
endef

define Package/unbound-host/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/unbound-host $(1)/usr/sbin/
endef

define Package/libunbound/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libunbound.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,unbound))
$(eval $(call BuildPackage,unbound-anchor))
$(eval $(call BuildPackage,unbound-control-setup))
$(eval $(call BuildPackage,unbound-host))
$(eval $(call BuildPackage,libunbound))
