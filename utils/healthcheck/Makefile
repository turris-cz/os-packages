#
# Copyright (C) 2021 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=healthcheck
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/healthcheck.git
PKG_MIRROR_HASH:=e4252dfcac1f68d654df09837a62ec61731cd8cf6c1b78819ef9ccb86310141a
PKG_SOURCE_VERSION:=25a8bf360dd09ad9f368e28cd5b7f00b60ed71f5
#PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/healthcheck
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Healthcheck
  URL:=https://gitlab.nic.cz/turris/healthcheck
  DEPENDS:=\
    +python3-humanize \
    +python3-rich \
    +python3-crontab \
    +python3-uci
  VARIANT:=python3
endef

define Package/healthcheck/description
  Turris router health checking tool.
endef

define Py3Package/healthcheck/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/cron.d
	$(INSTALL_CONF) ./files/cron $(1)/etc/cron.d/healthcheck
endef

$(eval $(call Py3Package,healthcheck))
$(eval $(call BuildPackage,healthcheck))
$(eval $(call BuildPackage,healthcheck-src))
