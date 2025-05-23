#
# Copyright (C) 2017-2024 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-storage-module
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-storage-module.git
PKG_MIRROR_HASH:=58ed644da1c86ee85673253ce10bf144d164b47259d202da6048728e8a6b5765
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-storage-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller Storage module
  DEPENDS:= \
    +foris-controller \
    +btrfs-progs \
    +coreutils \
    +coreutils-stat \
    +rsync \
    +partx-utils \
    +blkid \
    +kmod-ata-ahci \
    +kmod-fs-btrfs \
    +kmod-nls-utf8 \
    +hd-idle
endef

define Package/foris-controller-storage-module/description
  This is a storage module for foris-controller.
endef

define Package/foris-controller-storage-module/conffiles
/etc/config/storage
endef

define Package/foris-controller-storage-module/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/foris-controller restart
	/etc/init.d/srv enable
fi
mkdir -p "$${IPKG_INSTROOT}"/srv
endef

define ForisControllerModule/foris-controller-storage-module/install
	$(INSTALL_DIR) $(1)/usr/libexec $(1)/etc/init.d $(1)/etc/config $(1)/etc/logrotate.d $(1)/usr/share/syslog-ng/include/scl/storage $(1)/etc/lighttpd/conf.d

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/format_and_set_srv.sh $(1)/usr/libexec
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/srv.init $(1)/etc/init.d/srv

	$(CP) $(PKG_BUILD_DIR)/scripts/syslog-ng.conf $(1)/usr/share/syslog-ng/include/scl/storage/plugin.conf
	$(CP) $(PKG_BUILD_DIR)/scripts/syslog-ng-logrotate.conf $(1)/etc/logrotate.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/syslog-ng.sh $(1)/usr/libexec/syslog-ng-srv.sh
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/lighttpd_srv_setting.sh $(1)/usr/libexec/lighttpd_srv_setting.sh
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/scripts/lighttpd.conf $(1)/etc/lighttpd/conf.d/45-srv.conf

	$(INSTALL_DATA) ./files/storage.uci $(1)/etc/config/storage

ifneq ($(CONFIG_RSYNC_xattr),y)
	sed -i 's|\(.*rsync .*\)X\(.*\)|\1\2|' $(1)/etc/init.d/srv
endif
endef

$(eval $(call ForisControllerModule,foris-controller-storage-module))
# call BuildPackage <= assures OWR build system that this is package
