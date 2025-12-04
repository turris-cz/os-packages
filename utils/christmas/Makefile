#
## Copyright (C) 2019-2022 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=christmas
PKG_VERSION:=1.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE.md

include $(INCLUDE_DIR)/package.mk

define Package/christmas
  TITLE:=Christmas
  DEPENDS:=+coreutils-sleep
  DEPENDS+=@(TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia||TARGET_mpc85xx_p2020_DEVICE_cznic_turris1x||TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng)
endef

define Package/christmas/description
  Shine Turris router like a Christmas tree
endef

define Package/christmas/conffiles
/etc/config/christmas
endef

Build/Compile:=:

define Package/christmas/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/christmas.sh $(1)/usr/bin/christmas

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/christmas.init $(1)/etc/init.d/christmas

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/christmas.uci $(1)/etc/config/christmas
endef

$(eval $(call BuildPackage,christmas))
