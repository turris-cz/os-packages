#
# Copyright (C) 2026 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=omnia-ng-wifi-detect
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/omnia-ng-wifi-detect
  TITLE:=Turris Omnia NG wifi firmware detector
  VERSION:=$(PKG_VERSION)
  RELEASE:=$(PKG_VERSION)-$(PKG_RELEASE)
  DEPENDS:=@TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng +i2c-tools +crypto-wrapper
endef

define Package/omnia-ng-wifi-detect/description
  Detects which wifi firmware should be used.
endef

# Build/Configure:=
Build/Compile:=

define Package/omnia-ng-wifi-detect/install
	$(INSTALL_DIR) $(1)/usr/libexec/wifi-detect
	$(INSTALL_BIN) ./files/wifi-detect.sh $(1)/usr/libexec/wifi-detect/
	$(INSTALL_DATA) ./files/board-2.bin.* $(1)/usr/libexec/wifi-detect/
	$(INSTALL_DATA) ./files/SN.txt $(1)/usr/libexec/wifi-detect/
endef

define Package/omnia-ng-wifi-detect/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
    /usr/libexec/wifi-detect/wifi-detect.sh
}
endef

$(eval $(call BuildPackage,omnia-ng-wifi-detect))
