#
# Copyright (C) 2018-2024 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=turrishw
PKG_VERSION:=1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/turrishw.git
PKG_MIRROR_HASH:=f8b49b5d06d288efb53ffb31ec4099502d768acb3b2fcaa3672bdfde797f1887
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=BSL-1.0
PKG_LICENSE_FILES:=LICENSE_1_0.txt

PKG_BUILD_DEPENDS:=python-hatchling/host

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/turrishw
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=turrishw
  DEPENDS:=+python3-light +python3-logging
endef

define Package/turrishw/description
  turrishw is a package for providing abstraction over available interfaces on various Turris (Mox, Omnia) routers.
endef

$(eval $(call Py3Package,turrishw))
$(eval $(call BuildPackage,turrishw))
$(eval $(call BuildPackage,turrishw-src))
