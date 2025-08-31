#
## Copyright (C) 2025 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=turris-omnia-ng-firmware
PKG_VERSION:=1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/turris-omnia-ng-firmware
  TITLE:=Firmware for Turris Omnia NG
  DEPENDS:=@TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng
  PROVIDES:=turris-nor-update-firmware
endef

define Package/turris-omnia-ng-firmware/description
  Stable firmware for Turris Omnia
endef

define Package/turris-omnia-ng-devel-firmware
  TITLE:=Data files for nor-update (development version)
  DEPENDS:=+turris-nor-update +rescue-image @TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng +turris-omnia-ng-firmware
  PROVIDES:=turris-nor-update-devel-firmware
  VERSION:=0.0
  RELEASE:=1
endef

define Package/turris-omnia-ng-devel-firmware/description
  Virtual package to pull in development versions of NOR images (U-Boot and Rescue)
  for Turris Omnia
endef

Build/Compile:=:

Package/turris-omnia-ng-devel-firmware/install:=:

define Package/turris-omnia-ng-firmware/install
	$(INSTALL_DIR) $(1)/usr/share/nor-update/
	$(INSTALL_DATA) ./files/* $(1)/usr/share/nor-update/
endef

$(eval $(call BuildPackage,turris-omnia-ng-firmware))
$(eval $(call BuildPackage,turris-omnia-ng-devel-firmware))
