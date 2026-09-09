#
# Copyright (C) 2025-2026 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-hwdb
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/turris-hwdb
	TITLE:=Turris supported hardware database
endef

define Package/turris-hwdb/description
	Description of supported peripherals and their classification
endef

define Package/turris-hwdb/install
	$(INSTALL_DIR) $(1)/usr/share/turris-hwdb/
	$(INSTALL_DATA) ./files/hwdb.sqlite3 $(1)/usr/share/turris-hwdb/
endef

Build/Compile:=

$(eval $(call BuildPacakge,turris-hwdb))
