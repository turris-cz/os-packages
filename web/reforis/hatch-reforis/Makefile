#
# Copyright (C) 2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hatch-reforis
PKG_VERSION:=0.2.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/hatch-reforis
PKG_MIRROR_HASH:=9795dedfd82542ccf22a8b4ad0cae1e246fe47f1475a5ef0c059b3d42628fbc0
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

HOST_BUILD_DEPENDS:= \
	python3/host \
	python-babel/host \
	python3-hatchling/host

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-host-build.mk

define Package/hatch-reforis
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis hatch utils
  URL:=https://gitlab.nic.cz/turris/reforis/hatch-reforis
  DEPENDS:=python3-babel python3-hatchling
  BUILDONLY:=1
endef

define Package/hatch-reforis/description
  Utils to build reforis and its plugins.
endef

$(eval $(call Py3Package,hatch-reforis))
$(eval $(call BuildPackage,hatch-reforis))
$(eval $(call BuildPackage,hatch-reforis-src))
$(eval $(call HostBuild))
