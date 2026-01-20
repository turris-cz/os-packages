#
# Copyright (C) 2019 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=notification-system
PKG_VERSION:=0.2.2
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/notification-system.git
PKG_MIRROR_HASH:=7f83d78d76bc75da172696776a79b3fc158401a91b9480f318008f91b4d889fe
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DEPENDS:=python-babel/host

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/notification-system
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Notification system
  URL:=https://gitlab.nic.cz/turris/notification-system
  DEPENDS:= \
        +python3-light \
        +python3-yaml \
        +python3-jinja2 \
        +python3-logging
  PROVIDES:=user-notify
  CONFLICTS:=user-notify
endef

define Package/notification-system/description
  Notification system is tool that offers easy way to create and read notifications.
endef

define Py3Package/notification-system/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/user_notify.config $(1)/etc/config/user_notify
endef

define Package/notification-system/conffiles
/etc/config/user_notify
endef

$(eval $(call Py3Package,notification-system))
$(eval $(call BuildPackage,notification-system))
$(eval $(call BuildPackage,notification-system-src))
