#
# Copyright (C) 2021 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-rich
PKG_VERSION:=10.15.2
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PYPI_NAME:=rich
PKG_HASH:=1dded089b79dd042b3ab5cd63439a338e16652001f0c16e73acdcf4997ad772d

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-rich
  SECTION:=lang-python
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Render rich text and more to the terminal
  URL:=https://github.com/willmcgugan/rich
  DEPENDS:=+python3-light
  VARIANT:=python3
endef

define Package/python3-rich/description
 Render rich text, tables, progress bars, syntax highlighting, markdown and more
 to the terminal.
endef

$(eval $(call Py3Package,python3-rich))
$(eval $(call BuildPackage,python3-rich))
$(eval $(call BuildPackage,python3-rich-src))
