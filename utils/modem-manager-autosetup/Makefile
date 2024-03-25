#
## Copyright (C) 2023 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=modem-manager-autosetup
PKG_VERSION:=1.1-2023-09-21
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

include $(INCLUDE_DIR)/package.mk

define Package/modem-manager-autosetup
  TITLE:=Automatic setup of Modem Manager
  DEPENDS:=+jq +modemmanager
endef

define Package/modem-manager-autosetup/description
  Script that tries to automatically configure 3/4/5G modem.
endef

define Package/modem-manager-autosetup/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/autosetup.sh $(1)/usr/sbin/modem-manager-autosetup
	$(INSTALL_DIR) $(1)/usr/share/modem-manager-autosetup
	# wget -O - https://raw.githubusercontent.com/LineageOS/android_vendor_lineage/181e5a2ed5e949bc8d1b389fea51baa83b68f12f/prebuilt/common/etc/apns-conf.xml | yq --input-format xml -o json | sed 's|"+@|"|'
	$(INSTALL_DATA) ./files/apns-conf.json $(1)/usr/share/modem-manager-autosetup
endef

Build/Compile:=:

define Package/modem-manager-autosetup/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo 'MAILTO=""' > /etc/cron.d/modem-manager-autosetup
	echo '*/2 * * * * root /usr/sbin/modem-manager-autosetup' >> /etc/cron.d/modem-manager-autosetup
}
endef

define Package/modem-manager-autosetup/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	rm -f /etc/cron.d/modem-manager-autosetup
}
endef

$(eval $(call BuildPackage,modem-manager-autosetup))
