#
# Copyright (C) 2017-2025 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pakon
PKG_VERSION:=2.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/pakon.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=b746a031cecc12a39640af550c01c0b0e7d8868b09a5b4c090700c72af660e8b

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/pakon
  SECTION:=collect
  CATEGORY:=Collect
  TITLE:=Network monitoring tool
  DEPENDS:=\
    +suricata-pakon \
    +suricata-conntrack-flows \
    +pakon-lists \
    +python3-light \
    +python3-logging \
    +python3-ctypes \
    +python3-cachetools \
    +python3-sqlite3 \
    +sqlite3-cli \
    +xz \
    +ouidb \
    +turris-auth \
    +lighttpd-mod-proxy
endef

define Package/pakon/description
  Simple daemon that is able to collect information about network traffic and store it locally.
endef

define Package/pakon/conffiles
/etc/config/pakon
endef

define Py3Package/pakon/install
	# WebApps
	$(INSTALL_DIR) $(1)/usr/share/turris-webapps/
	$(INSTALL_DATA) ./files/webapps-pakon.json $(1)/usr/share/turris-webapps/10_pakon.json
	$(INSTALL_DIR) $(1)/www/webapps-icons/
	$(INSTALL_DATA) ./files/pakon.png $(1)/www/webapps-icons/

	# Web
	$(INSTALL_DIR) $(1)/www/pakon
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/web/index.html $(1)/www/pakon
	$(CP) -r $(PKG_BUILD_DIR)/web/static $(1)/www/pakon
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/web/api.cgi $(1)/www/cgi-bin/pakon
	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d/
	$(INSTALL_DATA) ./files/lighttpd-pakon.conf $(1)/etc/lighttpd/conf.d/80-pakon.conf

	# PaKon itself
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
	$(INSTALL_DIR) $(1)/etc/suricata-pakon/output_conf.d
	$(INSTALL_DATA) ./files/pakon-output.yaml $(1)/etc/suricata-pakon/output_conf.d/pakon.yaml
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/pakon-monitor-init $(1)/etc/init.d/pakon-monitor
	$(INSTALL_BIN) ./files/pakon-handler-init $(1)/etc/init.d/pakon-handler
	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_DATA) ./files/pakon-cron $(1)/etc/cron.d/pakon
	$(INSTALL_DIR) $(1)/usr/share/pakon-light/domains_replace
	$(INSTALL_DIR) $(1)/usr/share/pakon-light/domains_ignore
	$(INSTALL_DIR) $(1)/usr/libexec/pakon-light/
	$(INSTALL_BIN) ./files/backup_sqlite.sh $(1)/usr/libexec/pakon-light/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/pakon-uci.example $(1)/etc/config/pakon
endef

define Package/pakon/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
	/usr/bin/pakon-maintain create-databases
	/etc/init.d/pakon-monitor enable
	/etc/init.d/pakon-monitor restart 2>/dev/null
	/etc/init.d/pakon-handler enable
	/etc/init.d/pakon-handler restart 2>/dev/null
	/etc/init.d/suricata-pakon restart 2>/dev/null
	/etc/init.d/lighttpd restart 2>/dev/null
fi
endef

define Package/pakon/postrm
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
	/etc/init.d/lighttpd restart 2>/dev/null
fi
endef

define Package/pakon/prerm
#!/bin/sh
/etc/init.d/pakon-monitor disable
/etc/init.d/pakon-monitor stop
/etc/init.d/pakon-handler disable
/etc/init.d/pakon-handler stop
endef

$(eval $(call Py3Package,pakon))
$(eval $(call BuildPackage,pakon))
$(eval $(call BuildPackage,pakon-src))
