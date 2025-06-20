#
## Copyright (C) 2018-2025, 2022 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=user-notify
PKG_VERSION:=62.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/user-notify.git
PKG_MIRROR_HASH:=2c1a80faa498f42a225d26a4ab688150b48f8cf14d22467e4d5b8d80c013d295,
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/user-notify
  TITLE:=Turris user notifications
  DEPENDS:=+at +msmtp +ca-certificates +crypto-wrapper +sentinel-certgen +gettext-tools +create_notification +curl
endef

Build/Compile:=:

define Package/user-notify/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/scripts/list_notifications $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/scripts/notifier $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/scripts/user-notify-cleaner $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/scripts/user-notify-display $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/user_notify.uci $(1)/etc/config/user_notify

	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_DATA) ./files/user_notify.cron $(1)/etc/cron.d/user_notify
endef

define Package/user-notify/conffiles
/etc/config/user_notify
endef


define Package/create_notification
  TITLE:=Create Turris user notification
  DEPENDS:=+gettext-tools
endef

define Package/create_notification/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/scripts/create_notification $(1)/usr/bin/
endef

$(eval $(call BuildPackage,user-notify))
$(eval $(call BuildPackage,create_notification))
