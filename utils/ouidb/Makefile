#
# Copyright (C) 2013-2020, 2022 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ouidb
PKG_VERSION:=20261108
PKG_RELEASE:=1

PKG_SOURCE_VERSION:=52693c47e0321ced967cdf311fc1bfe6203e581d
PKG_SOURCE_URL:=https://github.com/wireshark/wireshark/raw/$(PKG_SOURCE_VERSION)/epan
PKG_SOURCE_URL_FILE:=manuf-data.c
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).c
PKG_HASH:=01473a7ff5845768fffa034da50671bed2c4664a0fcb14a7ee980ecce1def1ac

UNPACK_CMD:=:

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/ouidb
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=OUI database
endef

define Build/Compile
	awk -f ./files/oui-db.awk $(DL_DIR)/$(PKG_SOURCE) > $(PKG_BUILD_DIR)/oui.db
endef

define Package/ouidb/install
	$(INSTALL_DIR) $(1)/usr/bin/ $(1)/usr/share/ouidb/
	$(INSTALL_BIN) ./files/ouidb $(1)/usr/bin/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/oui.db $(1)/usr/share/ouidb/
endef

$(eval $(call BuildPackage,ouidb))
