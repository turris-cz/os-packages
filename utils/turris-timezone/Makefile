#
# Copyright (C) 2023 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turris-timezone
PKG_VERSION:=0.3.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/$(PKG_NAME)/-/archive/v$(PKG_VERSION)/
PKG_HASH:=2575dd863634cbed3568d95dbb67cdb3c661559d6c76032b6c5ce85dbc93acba
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-v$(PKG_VERSION)

PKG_BUILD_DEPENDS:=\
	python-hatchling/host \
	python-l18n/host \
	python-six/host \
	python-pytz/host

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/turris-timezone
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Turris timezone
  URL:=https://gitlab.nic.cz/turris/foris-controller/turris-timezone/
  DEPENDS:=+python3-light
endef

define Package/turris-timezone/description
  Due to missing /usr/share/zoneinfo on OpenWrt, this package should
  provide some basic data extracted from /usr/share/zoneinfo of build machnine.
endef

$(eval $(call Py3Package,turris-timezone))
$(eval $(call BuildPackage,turris-timezone))
$(eval $(call BuildPackage,turris-timezone-src))
