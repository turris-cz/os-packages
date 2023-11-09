#
# Copyright (C) 2023 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-distutils
PKG_VERSION:=0.1.1
PKG_RELEASE:=1

PYPI_NAME:=reforis-distutils
PYPI_SOURCE_NAME:=reforis_distutils
PKG_HASH:=afeefe184448f51529501a03ab66deb5dee0b8b1612799f8f2b7a95d61069713

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

HOST_BUILD_DEPENDS:= \
	python3/host \
	python3-babel/host \
	node/host

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-host-build.mk

define Package/reforis-distutils
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis distutils
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-distutils
  DEPENDS:= \
      +python3-light \
      +python3-babel
  BUILDONLY:=1
endef

define Package/reforis-distutils/description
  Distutils to build reforis and its plugins.
endef

$(eval $(call Py3Package,reforis-distutils))
$(eval $(call BuildPackage,reforis-distutils))
$(eval $(call BuildPackage,reforis-distutils-src))
$(eval $(call HostBuild))
