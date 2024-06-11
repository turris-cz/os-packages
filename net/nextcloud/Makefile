#
# Copyright (C) 2018-2022 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nextcloud
PKG_VERSION:=27.1.10
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://download.nextcloud.com/server/releases/
PKG_HASH:=943e1270d771a7c80daa2b32e7294ce8c3b77b9eaef72ad8b38487d58c850756

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=AGPL-3.0
PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=0
PKG_UNPACK:=

include $(INCLUDE_DIR)/package.mk

define Package/nextcloud
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Nextcloud server
	URL:=https://nextcloud.com/
	DEPENDS=+php8-mod-opcache +php8-fpm +php8-cli +sudo +php8-mod-ctype +php8-mod-fileinfo +php8-mod-xmlreader +php8-mod-openssl +php8-mod-gd +php8-mod-xml +php8-mod-xmlwriter +php8-mod-mbstring +php8-mod-pcntl +php8-mod-opcache +php8-mod-session +php8-mod-simplexml +php8-mod-iconv +php8-mod-curl +php8-mod-zip +php8-mod-dom +php8-mod-sodium +coreutils-stat +php8 +lighttpd-mod-access +php8-mod-intl +php8-mod-filter +php8-mod-phar +php8-mod-gmp +php8-mod-bcmath +icu-full-data
endef

define Package/nextcloud-install
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Nextcloud server installation script
	DEPENDS=+nextcloud +mariadb-server +php8-mod-pdo-mysql +mariadb-client
endef

define Package/$(PKG_NAME)/description
  A safe home for all your data.
endef

define Package/$(PKG_NAME)_install/description
  Nextcloud is a safe home for all your data. And this is simple installation script.
endef

define Build/Compile
endef

define Build/Install
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/srv/www/nextcloud
	$(INSTALL_DIR) $(1)/usr/share/nextcloud
	$(INSTALL_DATA) ./files/placeholder.php $(1)/usr/share/nextcloud/placeholder.php
	$(INSTALL_DATA) $(DL_DIR)/$(PKG_SOURCE) $(1)/usr/share/nextcloud/nextcloud.tar.bz2
	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d/
	$(INSTALL_DATA) ./files/nextcloud.conf $(1)/etc/lighttpd/conf.d/80-nextcloud.conf
	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_DATA) ./files/nextcloud.cron $(1)/etc/cron.d/nextcloud
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/nextcloud-cron.sh $(1)/usr/bin/nextcloud-cron.sh
endef

define Package/$(PKG_NAME)-install/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/easy_install.sh $(1)/usr/bin/nextcloud_install
	$(INSTALL_BIN) ./files/nextcloud_disable_trusted_domains.sh $(1)/usr/bin/nextcloud_disable_trusted_domains
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
# check if we are on real system
if [ -z "$$IPKG_INSTROOT" ]; then
	if [ -f /srv/www/nextcloud/config/config.php ]; then
		if [ ! -f /srv/www/nextcloud/remote.php ]; then
			tar -C /srv/www/nextcloud --strip-components 1 -oxjf /usr/share/nextcloud/nextcloud.tar.bz2
			date +%s > /srv/www/nextcloud/data/.last_update_check
			chown -Rh nobody:nogroup /srv/www/nextcloud
		fi
		cd /srv/www/nextcloud/
		VER="`cat ./config/config.php | sed -n 's|.*version[^0-9]*\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)\..*|\1\2\3|p'`"
		sed -i 's|\(.*dbhost.*=>.*\)localhost\(.\),|\1127.0.0.1\2,|' config/config.php
		if [ -n "$$VER" ] && [ $$VER -lt "`echo $(PKG_VERSION) | sed 's|\.||g'`" ]; then
			sudo -u nobody php-cli ./occ upgrade --no-interaction
		fi
	else
		cp /usr/share/nextcloud/placeholder.php /srv/www/nextcloud/index.php
		/etc/init.d/lighttpd restart
	fi
fi
chown -R nobody:nogroup "$$IPKG_INSTROOT"/srv/www/nextcloud/
chown nobody:nogroup "$$IPKG_INSTROOT"/usr/bin/nextcloud-cron.sh
endef

$(eval $(call BuildPackage,nextcloud))
$(eval $(call BuildPackage,nextcloud-install))
