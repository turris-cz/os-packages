#
# Copyright (C) 2024-2025 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-supervisor
PKG_VERSION:=4.2.5
PKG_RELEASE:=1

PYPI_NAME:=supervisor
PKG_HASH:=34761bae1a23c58192281a5115fb07fbf22c9b0133c08166beffc70fed3ebc12

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=BSD
PKG_LICENSE_FILES:=COPYING

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-supervisor
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=A system for controlling process state under UNIX
  URL:=http://supervisord.org/
  DEPENDS:=+python3-light
endef

define Package/python3-supervisor/description
  Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.
endef

$(eval $(call Py3Package,python3-supervisor))
$(eval $(call BuildPackage,python3-supervisor))
$(eval $(call BuildPackage,python3-supervisor-src))
