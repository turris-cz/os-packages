#
# Copyright (C) 2021-2024 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-crontab
PKG_VERSION:=1.0.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_LICENSE:=LGPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE3

PYPI_NAME:=crontab
PKG_HASH:=89477e3f93c81365e738d5ee2659509e6373bb2846de13922663e79aa74c6b91

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

PYTHON3_PKG_SETUP_ARGS :=

define Package/python3-crontab
  SECTION:=lang-python
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Parse and use crontab schedules in Python
  URL:=https://github.com/josiahcarlson/parse-crontab
  DEPENDS:=+python3-light
endef

define Package/python3-crontab/description
 This package intends to offer a method of parsing crontab schedule entries and
 determining when an item should next be run. More specifically, it calculates a
 delay in seconds from when the .next() method is called to when the item should
 next be executed.
endef

$(eval $(call Py3Package,python3-crontab))
$(eval $(call BuildPackage,python3-crontab))
$(eval $(call BuildPackage,python3-crontab-src))
