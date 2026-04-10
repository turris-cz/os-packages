#
# Copyright (C) 2026 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-blinker
PKG_VERSION:=1.9.0
PKG_RELEASE:=1

PYPI_NAME:=blinker
PKG_HASH:=b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=COPYING

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-blinker
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Fast dispatching system
  URL:=https://github.com/pallets-eco/blinker/
  DEPENDS:=+python3-light
endef

define Package/python3-blinker/description
  Blinker provides a fast dispatching system that allows any number of
  interested parties to subscribe to events, or "signals".
endef

$(eval $(call Py3Package,python3-blinker))
$(eval $(call BuildPackage,python3-blinker))
$(eval $(call BuildPackage,python3-blinker-src))
