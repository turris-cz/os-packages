#
# Copyright (C) 2019 - 2025 CZ.NIC z.s.p.o
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=common_passwords
PKG_VERSION:=20250402
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/common_passwords
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Updated lists of commonly used paswords
endef

define Package/common_passwords/description
 This package provides built-in lists of commonly used passwords users can check their passwords against
 and periodic updates of these lists.
endef

Build/Compile:=:

define Package/common_passwords/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/update-common-passwords.sh $(1)/usr/bin/update-common-passwords.sh

	$(INSTALL_DIR) $(1)/usr/share/common_passwords
	$(INSTALL_DATA) ./files/haas_passwords $(1)/usr/share/common_passwords/haas_passwords
	$(INSTALL_DATA) ./files/sentinel_passwords $(1)/usr/share/common_passwords/sentinel_passwords

	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_DATA) ./files/update-common-passwords.cron $(1)/etc/cron.d/update-common-passwords
endef

$(eval $(call BuildPackage,common_passwords))
