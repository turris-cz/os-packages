#
## Copyright (C) 2019 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=cronie
PKG_VERSION:=1.6.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/cronie-crond/cronie/archive
PKG_HASH:=1ddbc8f8d07dfe1d45998b0a0cbd9a216cd4d7bc64d1626b2bc8b3a69e4641d1

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=ISC
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DIR:=$(BUILD_DIR)/cronie-cronie-$(PKG_VERSION)
PKG_INSTALL:=1
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/autotools.mk

define Package/cronie
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=Cronie standard Unix crond
  URL:=https://github.com/cronie-crond/cronie
  DEPENDS:=@(!BUSYBOX_CONFIG_CROND&&!BUSYBOX_CONFIG_CRONTAB)
  USERID:=cron=16:cron=16
endef

define Package/cronie/description
  Cronie contains the standard UNIX daemon crond that runs specified programs at
  scheduled times and related tools. It is based on the original cron and has
  security and configuration enhancements like the ability to use pam and SELinux.
endef

# the default editor is /usr/bin/vi, but OpenWrt has vi in /bin/vi
CONFIGURE_ARGS += \
	--enable-syscrontab \
	--without-selinux \
	--without-pam \
	--with-inotify \
	--with-daemon_username=cron \
	--with-daemon_groupname=cron \
	--with-editor=/bin/vi \
	--disable-anacron
CONFIGURE_VARS += \
		SPOOL_DIR=/var/spool/cron/crontabs

define Package/cronie/conffiles
/etc/config/cronie
endef

define Package/cronie/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/crontab $(1)/usr/bin/crontab
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/cronnext $(1)/usr/bin/cronnext
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/crond $(1)/usr/sbin/crond
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/cron.init $(1)/etc/init.d/cron
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/cronie.uci $(1)/etc/config/cronie

	$(INSTALL_DIR) $(1)/etc/cron.d
	touch $(1)/etc/cron.d/.keep
	$(INSTALL_DIR) $(1)/etc/crontabs
	touch $(1)/etc/crontabs/.keep
endef

$(eval $(call BuildPackage,cronie))
