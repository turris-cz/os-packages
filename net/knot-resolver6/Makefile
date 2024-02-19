#
# Copyright (C) 2015-2023 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PKG_RELRO_FULL:=0

include $(TOPDIR)/rules.mk

PKG_NAME:=knot-resolver6
PKG_VERSION:=6.0.6
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/knot/knot-resolver.git
PKG_MIRROR_HASH:=7f68c99d6717c6c931a3533f320b9cf5d1d9648823eade2e7d08e8990e2c4d3d
PKG_SOURCE_VERSION:=v${PKG_VERSION}

PKG_MAINTAINER:=Knot Resolver <knot-resolver@labs.nic.cz>
PKG_LICENSE:=GPL-3.0-later
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DEPENDS:=meson/host protobuf-c/host python-poetry-core/host

PKG_INSTALL:=1

PYTHON3_PKG_SETUP_DIR:=$(PKG_BUILD_DIR)/manager
PYTHON3_PKG_BUILD:=0
PYTHON3_PKG_WHEEL_NAME:=knot_resolver_manager
PYTHON3_PKG_WHEEL_VERSION:=0.1.0
Hooks/Configure/Post+=Py3Build/FindStdlibDepends

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

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

define Package/knot-resolver6-manager
  TITLE:=Knot DNS Resolver manager
  DEPENDS=\
    +knot-resolver6 \
    +python3-aiohttp \
    +python3-light \
    +python3-supervisord \
    +python3-typing-extensions \
    +python3-yaml
endef

define Py3Package/knot-resolver6-manager/install
	if [ -d $(PKG_INSTALL_DIR)/usr/bin ]; then \
		$(INSTALL_DIR) $(1)/usr/bin ; \
		$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/ ; \
	fi
	$(INSTALL_DIR) $(1)/etc/knot-resolver
	$(INSTALL_DATA) files/config.yaml $(1)/etc/knot-resolver
endef

define Package/knot-resolver6-manager/description
  Management tool for Knot Resolver.
endef

define Package/knot-resolver6/config
	source "$(SOURCE)/Config.in"
endef

MESON_ARGS+= \
	$(if $(CONFIG_PACKAGE_knot-resolver_dnstap), -Ddnstap=enabled,-Ddnstap=disabled) \
	-Dcapng=disabled \
	-Dmanager=disabled \
	-Dconfig_tests=disabled \
	-Ddoc=disabled \
	-Dinstall_kresd_conf=disabled \
	-Dinstall_root_keys=disabled \
	-Dkeyfile_default=/etc/root.keys \
	-Dprefix=/usr \
	-Dunit_tests=disabled \
	-Dutils=enabled

define Package/knot-resolver6/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/kresd $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/kres-cache-gc $(1)/usr/sbin/

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

define Package/knot-resolver6-manager/install
	$(call Python3/Run, \
		$(PKG_BUILD_DIR), \
		-m installer \
			--destdir "$(1)" \
			--no-compile-bytecode \
			--prefix /usr \
			"$(PYTHON3_PKG_BUILD_DIR)"/openwrt-build/$(PYTHON3_PKG_WHEEL_NAME)-$(PYTHON3_PKG_WHEEL_VERSION)-*.whl \
		, \
		$(PYTHON3_PKG_INSTALL_VARS) \
	)
endef

define Build/Compile
	$(call Build/Compile/Meson)
	$(call Py3Build/Compile)
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
$(eval $(call Py3Package,knot-resolver6-manager))
$(eval $(call BuildPackage,knot-resolver6-manager))
