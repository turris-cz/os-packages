#
# Copyright (C) 2016-2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=schnapps
PKG_VERSION:=2.13.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/schnapps.git
PKG_MIRROR_HASH:=09b6c2cbd8a91b4b5d35e67379516e3c8c1426fa1e137f2579311bb4ca21feef
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@nic.cz>
PKG_LICENSE:=GPL-2.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/schnapps
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Filesystem
  TITLE:=Btrfs snapshots management tool
  DEPENDS:=+btrfs-progs +mount-utils +tar
endef

define Package/schnapps/description
  Schnapps is a simple tool to make snapshot management easy. It has plenty of
  assumptions hardcoded and it is quite slow, but it has almost no dependencies
  and it is simple.
endef

define Package/schnapps/conffiles
/etc/config/schnapps
/etc/cron.d/schnapps
endef

define Build/Compile
	sed -i 's|@VERSION@|$(PKG_VERSION)|g' $(PKG_BUILD_DIR)/schnapps.sh
endef

define Package/schnapps/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/schnapps.sh $(1)/usr/bin/schnapps

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/schnapps.uci $(1)/etc/config/schnapps
	$(INSTALL_DIR) $(1)/etc/schnapps/rollback.d/
	$(INSTALL_BIN) ./files/cert-backup_hook.sh $(1)/etc/schnapps/rollback.d/10_cert-backup.sh
	$(INSTALL_BIN) ./files/approvals_purge.sh $(1)/etc/schnapps/rollback.d/20_approvals_purge.sh

	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/schnapps.cron $(1)/etc/cron.d/schnapps

	$(INSTALL_DIR) $(1)/etc/updater/hook_preupdate $(1)/etc/updater/hook_postupdate
	$(INSTALL_BIN) ./files/updater_preupdate.sh $(1)/etc/updater/hook_preupdate/05_schnapps.sh
	$(INSTALL_BIN) ./files/updater_postupdate.sh $(1)/etc/updater/hook_postupdate/95_schnapps.sh
endef

$(eval $(call BuildPackage,schnapps))
