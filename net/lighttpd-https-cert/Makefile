#
## Copyright (C) 2013-2022 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=lighttpd-https-cert
PKG_VERSION:=6.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0

include $(INCLUDE_DIR)/package.mk

define Package/lighttpd-https-cert
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Lighttpd HTTPS support
  DEPENDS:=+lighttpd-mod-openssl
endef

define Package/lighttpd-https-cert/install
	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d/ $(1)/etc/init.d
	$(INSTALL_CONF) ./files/ssl-enable.conf $(1)/etc/lighttpd/conf.d/40-ssl-enable.conf
	$(INSTALL_BIN) ./files/lighttpd-https-cert.init $(1)/etc/init.d/lighttpd-https-cert
endef

define Package/lighttpd-https-cert/postrm
#!/bin/sh
/etc/init.d/lighttpd restart
endef

define Package/lighttpd-https-cert/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/lighttpd-https-cert enable
fi
endef

Build/Compile:=:

$(eval $(call BuildPackage,lighttpd-https-cert))
