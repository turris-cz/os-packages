#
## Copyright (C) 2018-2019 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel-certgen
PKG_VERSION:=6.2
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/sentinel/certgen.git
PKG_MIRROR_HASH:=cbb38f7b449a530c0360371764fa25a688dcf7b67630217d67525db9c70bc972
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE.md

PYTHON3_PKG_FORCE_DISTUTILS_SETUP:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/sentinel-certgen
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=Certgen
  URL:=https://gitlab.nic.cz/turris/sentinel/certgen
  DEPENDS:=+python3-light +python3-six +python3-requests +python3-cryptography +crypto-wrapper
endef

define Package/sentinel-certgen/description
  Client application for automated passwords and certificates retrieval.
endef

$(eval $(call Py3Package,sentinel-certgen))
$(eval $(call BuildPackage,sentinel-certgen))
$(eval $(call BuildPackage,sentinel-certgen-src))
