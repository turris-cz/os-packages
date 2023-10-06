#
# Copyright (C) 2015-2021 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PKG_RELRO_FULL:=0

include $(TOPDIR)/rules.mk

PKG_NAME:=knot-resolver
PKG_VERSION:=5.7.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://secure.nic.cz/files/knot-resolver
PKG_HASH:=383ef6db1cccabd2dd788ea9385f05e98a2bafdfeb7f0eda57ff9d572f4fad71

PKG_MAINTAINER:=Knot DNS <knot-dns@labs.nic.cz>
PKG_LICENSE:=GPL-3.0-later
PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

define Package/knot-resolver
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Knot DNS Resolver
  URL:=https://www.knot-resolver.cz
  DEPENDS=\
    +dnssec-rootkey \
    +knot-libs \
    +knot-libzscanner \
    +libnghttp2 \
    +libstdcpp \
    +libuv \
    +lmdb \
    +luajit \
    +resolver-conf \
    PACKAGE_knot-resolver_dnstap:libfstrm \
    PACKAGE_knot-resolver_dnstap:libprotobuf-c
  PROVIDES:=dns-resolver
  USERID:=kresd=3536:kresd=3536
endef

define Package/knot-resolver/description
  The Knot Resolver is a caching full resolver
  implementation, including both a resolver library and a daemon.
endef

define Package/knot-resolver/config
	source "$(SOURCE)/Config.in"
endef

MESON_ARGS+= \
	$(if $(CONFIG_PACKAGE_knot-resolver_dnstap), -Ddnstap=enabled,-Ddnstap=disabled) \
	-Dcapng=disabled \
	-Dclient=disabled \
	-Dconfig_tests=disabled \
	-Ddoc=disabled \
	-Dinstall_kresd_conf=disabled \
	-Dinstall_root_keys=disabled \
	-Dkeyfile_default=/etc/root.keys \
	-Dprefix=/usr \
	-Dunit_tests=disabled \
	-Dutils=disabled

define Package/knot-resolver/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/kresd $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/usr/lib/knot-resolver
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/knot-resolver/{*.lua,*.so} $(1)/usr/lib/knot-resolver/
	$(INSTALL_DIR) $(1)/usr/lib/knot-resolver/kres_modules
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/knot-resolver/kres_modules/{*.lua,*.so} $(1)/usr/lib/knot-resolver/kres_modules/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/kresd.init $(1)/etc/init.d/kresd

	$(INSTALL_DIR) $(1)/etc/knot-resolver
	$(CP) $(PKG_INSTALL_DIR)/etc/knot-resolver/root.hints $(1)/etc/knot-resolver/

	$(INSTALL_DIR) $(1)/etc/kresd
endef

define Package/knot-resolver/postinst
#!/bin/sh
set -x
if [ -z "$$IPKG_INSTROOT" ]; then
/etc/init.d/dnsmasq restart
sleep 2 # Cooldown for above (problems in times of reinstall)

# convert static_domain from kresd to common section
stat_dom=`uci -q get resolver.kresd.static_domains`
if [ ! -z "$$stat_dom" ]; then
	uci set resolver.common.static_domains="$$stat_dom"
	uci delete resolver.kresd.static_domains
	uci commit resolver
fi
/etc/init.d/resolver restart

# convert hostname_config from option to list
hostnames=`uci show resolver.kresd.hostname_config`
item_count=`echo "$$hostnames"| tr -cd "'"|wc -c`
if [ "$$item_count" -gt  "2" ] || [ "$$item_count" == "0" ]; then
	echo "resolver.kresd.hostname_config was already converted to list"
else
	echo "converting resolver.kresd.hostname_config to list"
	val=`uci get resolver.kresd.hostname_config`
	uci delete resolver.kresd.hostname_config
	uci add_list resolver.kresd.hostname_config=$$val
	uci commit resolver
fi

if [ "`uci -q get resolver.common.prefered_resolver`" = kresd ] && uci -q get resolver.common.forward_upstream | egrep -q '(1|yes|true|enabled|on)'; then
	ping -c 1 repo.turris.cz 2> /dev/null >&2 || {
		uci set resolver.common.forward_upstream=0
		uci commit
		/etc/init.d/resolver restart
		if ping -c 1 repo.turris.cz 2> /dev/null >&2; then
			create_notification -s error "DNS servery vašeho poskytovatele internetu nefungují úplně dobře - pravděpodobně nepodporují DNSSEC. Bylo proto vypnuto forwardování a váš router bude nyní vyhodnocovat DNS dotazy sám." "Your ISPs DNS servers does not work properly - most likely they don't support DNSSEC. Therefore DNS forwarding was turned off and your router will now resolve all DNS queries by itself."
		else
			uci set resolver.common.forward_upstream=1
			uci commit
			/etc/init.d/resolver restart
		fi
	}
fi
fi
endef

define Package/knot-resolver/prerm
#!/bin/sh
set -ex
if [ -z "$$IPKG_INSTROOT" ]; then
# Remove the script if it is there.
if [ -e /etc/init.d/kresd ] ; then /etc/init.d/kresd stop ; /etc/init.d/kresd disable ;  fi
fi
endef

define Package/knot-resolver/postrm
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
[ \! -x /etc/init.d/resolver ] || /etc/init.d/resolver restart
fi
endef

$(eval $(call BuildPackage,knot-resolver))
