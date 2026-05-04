#
# Copyright (C) 2022 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=morce
PKG_VERSION:=1.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/morce.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=473f87c0f7fdc8d761d6109c857c73fd96d4fb5de5d54e1629aae796b5d7e62b

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/morce
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MORCE - Simple IDS integration
  DEPENDS:=+libuci-lua +luasql-sqlite3 +snort3 +sqlite3-cli +tar +wget-ssl
endef

define Package/morce/description
  Simple integration of Snort IDS into Turris OS
endef

Build/Compile:=:

define Package/morce/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init/morce $(1)/etc/init.d/morce

	$(INSTALL_DIR) $(1)/usr/share/morce/loggers/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/logger/alert_morce.lua $(1)/usr/share/morce/loggers/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/share/aggregate.sql $(1)/usr/share/morce/

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/uci/morce $(1)/etc/config

	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_DATA) ./files/morce.cron $(1)/etc/cron.d/morce-aggregate
endef

define Package/morce/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
    /etc/init.d/morce enable
    /etc/init.d/morce restart 2>/dev/null
fi
[ -e "$$IPKG_INSTROOT"/etc/cron.d/morce-rules-refresh ] || {
    echo 'MAILTO=""'
    echo "$$(($$RANDOM % 59)) $$(($$RANDOM % 4 + 1)) * * * root /etc/init.d/morce enabled && /etc/init.d/morce update_rules" 
} > "$$IPKG_INSTROOT"/etc/cron.d/morce-rules-refresh
endef

define Package/morce/postrm
#!/bin/sh
rm -f "$$IPKG_INSTROOT"/etc/cron.d/morce-rules-refresh
endef

define Package/morce/conffiles
/etc/config/morce
endef

$(eval $(call BuildPackage,morce))
