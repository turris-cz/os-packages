#
## Copyright (C) 2022 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rainbow
PKG_VERSION:=0.1.4
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/rainbow-ng.git
PKG_MIRROR_HASH:=503450304dab939340a5f167aae5c605b4511f2da990cc5a71e221ffda00ce3a
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/Common
  TITLE:=rainbow
  DEPENDS:=@(TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia||TARGET_mpc85xx_p2020_DEVICE_cznic_turris1x||TARGET_mvebu_cortexa53_DEVICE_cznic_turris-mox)
  URL:=https://gitlab.nic.cz/turris/rainbow-ng
endef

define Package/rainbow
  $(call Package/Common)
  DEPENDS+= +rainbow-backend +flock
  PROVIDES:=turris-rainbow
endef

define Package/rainbow-button-sync
  $(call Package/Common)
  TITLE+=-button-sync
endef

define Package/rainbow-animator
  $(call Package/Common)
  TITLE+=-animator
  DEPENDS+= +python3-base
endef

define Package/omnia-rainbow-backend
  TITLE:=omnia-rainbow-backend
  DEPENDS:=\
    @TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia \
    +kmod-leds-turris-omnia \
    +rainbow-button-sync
  PROVIDES:=rainbow-backend
endef

define Package/mox-rainbow-backend
  TITLE:=mox-rainbow-backend
  DEPENDS:=\
    @TARGET_mvebu_cortexa53_DEVICE_cznic_turris-mox \
    +kmod-ledtrig-activity \
    +python3-uci \
    +rainbow-button-sync
  PROVIDES:=rainbow-backend
endef

define Package/turris1x-rainbow-backend
  TITLE:=turris1x-rainbow-backend
  DEPENDS:=\
    @TARGET_mpc85xx_p2020_DEVICE_cznic_turris1x \
    +kmod-leds-turris-1x \
    +rainbow-button-sync
  PROVIDES:=rainbow-backend
endef


define Package/rainbow/description
  LEDs control on Turris Omnia, Mox and 1.x routers.
endef

define Package/rainbow-button-sync/description
  Button synchronization extension for Turris Rainbow. This is used to synchronize system configuration with hardware button.
endef

define Package/rainbow-animator/description
  Animation extension for Turris Rainbow. This is used to animate leds in case of missing or unusable kernel support.
endef

define Package/rainbow/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/rainbow.init $(1)/etc/init.d/rainbow
	$(INSTALL_DIR) $(1)/etc/config/
	touch $(1)/etc/config/rainbow

	cd $(PKG_BUILD_DIR); make rainbow-install DESTDIR=$(1)
endef

define Package/rainbow-button-sync/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/rainbow-button-sync.init $(1)/etc/init.d/rainbow-button-sync

	cd $(PKG_BUILD_DIR); make button-sync-install DESTDIR=$(1)
endef

define Package/rainbow-animator/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/rainbow-animator.init $(1)/etc/init.d/rainbow-animator

	cd $(PKG_BUILD_DIR); make animator-install DESTDIR=$(1)
endef

define Package/omnia-rainbow-backend/install
	cd $(PKG_BUILD_DIR); make omnia-install DESTDIR=$(1)
endef

define Package/mox-rainbow-backend/install
	cd $(PKG_BUILD_DIR); make mox-install DESTDIR=$(1)
endef

define Package/turris1x-rainbow-backend/install
	cd $(PKG_BUILD_DIR); make turris1x-install DESTDIR=$(1)
endef

define Package/rainbow/conffiles
/etc/config/rainbow
endef

Build/Compile:=:

define Package/rainbow/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
	/etc/init.d/rainbow enable 2>/dev/null || true
	/etc/init.d/rainbow restart 2>/dev/null || true
}
endef

define Package/rainbow/prerm
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
	/etc/init.d/rainbow stop
	/etc/init.d/rainbow disable
	rainbow all auto white
}
endef

$(eval $(call BuildPackage,rainbow))
$(eval $(call BuildPackage,rainbow-button-sync))
$(eval $(call BuildPackage,rainbow-animator))
$(eval $(call BuildPackage,omnia-rainbow-backend))
$(eval $(call BuildPackage,mox-rainbow-backend))
$(eval $(call BuildPackage,turris1x-rainbow-backend))
