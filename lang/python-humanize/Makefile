#
# Copyright (C) 2021 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-humanize
PKG_VERSION:=3.13.1
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PYPI_NAME:=humanize
PKG_HASH:=12f113f2e369dac7f35d3823f49262934f4a22a53a6d3d4c86b736f50db88c7b

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-humanize
  SECTION:=lang-python
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Python humanize utilities
  URL:=https://github.com/jmoiron/humanize
  DEPENDS:=+python3-light
  VARIANT:=python3
endef

define Package/python3-periphery/description
 This modest package contains various common humanization utilities, like
 turning a number into a fuzzy human-readable duration ("3 minutes ago") or into
 a human-readable size or throughput.
endef

$(eval $(call Py3Package,python3-humanize))
$(eval $(call BuildPackage,python3-humanize))
$(eval $(call BuildPackage,python3-humanize-src))
