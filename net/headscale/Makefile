#
# Copyright (C) 2026 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=headscale
PKG_VERSION:=0.28.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/juanfont/headscale/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=cb38683998d13d2700df258a81c00add199dccb999b1dacc4491305cdaa67db3

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/juanfont/headscale
GO_PKG_BUILD_PKG:=github.com/juanfont/headscale/cmd/headscale

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/headscale
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Self-hosted Tailscale control server
  URL:=https://github.com/juanfont/headscale
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
  USERID:=headscale=5830:headscale=5830
endef

define Package/headscale/description
  Headscale is an open source, self-hosted implementation of the Tailscale
  control server. This package installs the server with procd init script and
  UCI configuration (/etc/config/headscale).
endef

define Package/headscale/conffiles
/etc/config/headscale
/etc/headscale/acl.hujson
endef

define Package/headscale/install
	$(call GoPackage/Package/Install/Bin,$(1))
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/config $(1)/etc/headscale
	$(INSTALL_BIN) ./files/headscale.init $(1)/etc/init.d/headscale
	$(INSTALL_CONF) ./files/headscale.uci $(1)/etc/config/headscale
	$(INSTALL_DATA) ./files/acl.hujson $(1)/etc/headscale/acl.hujson
endef

define Package/headscale/postrm
#!/bin/sh
# Do not touch the firewall on upgrade (binary is already present then)
if [ -z "$${IPKG_INSTROOT}" ] && [ ! -x /usr/bin/headscale ]; then
	uci -q delete firewall.headscale_stun
	uci -q commit firewall && /etc/init.d/firewall reload >/dev/null 2>&1
fi
exit 0
endef


define Package/headscale-lighttpd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Headscale HTTPS reverse proxy with Let's Encrypt
  URL:=https://github.com/juanfont/headscale
  DEPENDS:=+headscale +lighttpd \
    +lighttpd-mod-access \
    +lighttpd-mod-alias \
    +lighttpd-mod-openssl \
    +lighttpd-mod-proxy \
    +lighttpd-mod-redirect \
    +openssl-util \
    +acme-acmesh
endef

define Package/headscale-lighttpd/description
  Runs a dedicated lighttpd instance (independent of the system lighttpd
  serving reForis and LuCI) that terminates TLS for headscale, serves ACME
  challenges and manages a Let's Encrypt certificate for the server_url host.
  Only the headscale host name is served by this instance.
endef

define Package/headscale-lighttpd/install
	$(INSTALL_DIR) $(1)/usr/libexec/headscale $(1)/etc/hotplug.d/acme
	$(INSTALL_BIN) ./files/lighttpd-conf.sh $(1)/usr/libexec/headscale/lighttpd-conf.sh
	$(INSTALL_BIN) ./files/acme.hotplug $(1)/etc/hotplug.d/acme/50-headscale
endef

define Package/headscale-lighttpd/postrm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ] && [ ! -x /usr/libexec/headscale/lighttpd-conf.sh ]; then
	uci -q delete firewall.headscale_https
	uci -q delete firewall.headscale_acme
	uci -q commit firewall && /etc/init.d/firewall reload >/dev/null 2>&1
	uci -q delete acme.headscale
	uci -q commit acme
fi
exit 0
endef

$(eval $(call GoBinPackage,headscale))
$(eval $(call BuildPackage,headscale))
$(eval $(call BuildPackage,headscale-lighttpd))
