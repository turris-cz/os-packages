#
# Copyright (C) 2016-2025 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dnssec-rootkey
PKG_VERSION:=0.0.3
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/dnssec-rootkey
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=IP Addresses and Names
	TITLE:=DNSSEC rootkey
endef

define Package/dnssec-rootkey/postinst
#!/bin/sh
set -ex
[ -n "$$IPKG_INSTROOT" ] || {
/usr/sbin/cert-backup /etc/root.keys
}
endef

define Package/dnssec-rootkey/description
  Root key for DNSSEC resolver
endef

Build/Compile:=:

define Package/dnssec-rootkey/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_CONF) ./files/root.keys $(1)/etc/root.keys
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) ./files/rootkeys_backup.sh $(1)/usr/bin/rootkeys_backup.sh
	$(INSTALL_DIR) $(1)/etc/cron.d/
	$(INSTALL_CONF) ./files/rootkeys_backup.cron $(1)/etc/cron.d/rootkeys_backup
endef

$(eval $(call BuildPackage,dnssec-rootkey))
