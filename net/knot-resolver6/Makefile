#
# Copyright (C) 2015-2024 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PKG_RELRO_FULL:=0

include $(TOPDIR)/rules.mk

PKG_NAME:=knot-resolver6
PKG_VERSION:=6.0.8
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/knot/knot-resolver.git
PKG_MIRROR_HASH:=d646faacc27b730de969b1335d2ef0e89248e08ac638888595e2430d7e50e720
PKG_SOURCE_VERSION:=v${PKG_VERSION}

PKG_MAINTAINER:=Knot Resolver <knot-resolver@labs.nic.cz>
PKG_LICENSE:=GPL-3.0-later
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DEPENDS:=meson/host protobuf-c/host

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

define Package/knot-resolver6
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Knot Resolver
  URL:=https://www.knot-resolver.cz
  CONFLICTS:=knot-resolver
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

define Package/knot-resolver6/description
  The Knot Resolver is a caching full resolver
  implementation, including both a resolver library and a daemon.
endef

define Package/knot-resolver6/config
	source "$(SOURCE)/Config.in"
endef

MESON_ARGS+= \
	$(if $(CONFIG_PACKAGE_knot-resolver_dnstap), -Ddnstap=enabled,-Ddnstap=disabled) \
	-Dcapng=disabled \
	-Dconfig_tests=disabled \
	-Ddoc=disabled \
	-Dinstall_kresd_conf=disabled \
	-Dinstall_root_keys=disabled \
	-Dkeyfile_default=/etc/root.keys \
	-Dprefix=/usr \
	-Dunit_tests=disabled \
	-Dutils=disabled

define Package/knot-resolver6/install
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

define Package/knot-resolver6/postinst
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

define Package/knot-resolver6/prerm
#!/bin/sh
set -ex
if [ -z "$$IPKG_INSTROOT" ]; then
# Remove the script if it is there.
if [ -e /etc/init.d/kresd ] ; then /etc/init.d/kresd stop ; /etc/init.d/kresd disable ;  fi
fi
endef

define Package/knot-resolver6/postrm
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
[ \! -x /etc/init.d/resolver ] || /etc/init.d/resolver restart
fi
endef

$(eval $(call BuildPackage,knot-resolver6))
