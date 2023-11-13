#
# Copyright (C) 2023 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-l18n
PKG_VERSION:=2021.3
PKG_RELEASE:=1

PYPI_NAME:=l18n
PYPI_SOURCE_EXT:=tar.gz
PKG_HASH:=1956e890d673d17135cc20913253c154f6bc1c00266c22b7d503cc1a5a42d848

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

HOST_BUILD_DEPENDS:=python3/host \
                    python-build/host \
                    python-installer/host \
                    python-wheel/host

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-host-build.mk

define Package/python3-l18n
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Internationalization for pytz timezones and territories
  URL:=https://github.com/tkhyn/l18n
  DEPENDS:= \
	+python3 \
	+python3-six \
	+python3-pytz
endef

define Package/python3-l18n/description
  Locale internationalization package. Translations for places, timezones …
  Tested with the latest minor versions of Python 2 and 3.
  Supported languages: English, French, German, Czech, Chinese
endef

$(eval $(call Py3Package,python3-l18n))
$(eval $(call BuildPackage,python3-l18n))
$(eval $(call BuildPackage,python3-l18n-src))
$(eval $(call HostBuild))
