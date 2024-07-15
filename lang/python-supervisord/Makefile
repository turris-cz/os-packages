#
# Copyright (C) 2024 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-supervisord
PKG_VERSION:=4.2.5
PKG_RELEASE:=$(AUTORELEASE)

PKG_LICENSE:=BSD-derived
PKG_LICENSE_FILES:=LICENSES.txt

PYPI_NAME:=supervisor
PKG_HASH:=34761bae1a23c58192281a5115fb07fbf22c9b0133c08166beffc70fed3ebc12

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

PYTHON3_PKG_SETUP_ARGS :=

define Package/python3-supervisord
  SECTION:=lang-python
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Supervisor process control system for Unix (supervisord)
  URL:=https://github.com/Supervisor/supervisor
  DEPENDS:=
endef

define Package/python3-supervisord/description
 Supervisor is a client/server system that allows its users to control a number
 of processes on UNIX-like operating systems.
endef

$(eval $(call Py3Package,python3-supervisord))
$(eval $(call BuildPackage,python3-supervisord))
$(eval $(call BuildPackage,python3-supervisord-src))
