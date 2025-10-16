#
## Copyright (C) 2025 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=omnia-ng-crypto
PKG_VERSION:=0.0.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/omnia-ng-crypto.git
PKG_MIRROR_HASH:=1680d2f7891b780cd201622a0113bac1252f947b08dc2a2b38487514839f52f6
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE.md

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/omnia-ng-crypto
  TITLE:=OMNIA-NG CRYPTO
  URL:=https://gitlab.nic.cz/turris/omnia-ng-crypto
  DEPENDS:=+python3-light
  DEPENDS+=@TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng
endef

define Package/omnia-ng-crypto/description
  Command line tool to query crypto functions on Omnia NG
endef

$(eval $(call Py3Package,omnia-ng-crypto))
$(eval $(call BuildPackage,omnia-ng-crypto))
$(eval $(call BuildPackage,omnia-ng-crypto-src))
