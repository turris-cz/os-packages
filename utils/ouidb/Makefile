#
## Copyright (C) 2013-2026, 2022 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=ouidb
PKG_VERSION:=20260428
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/ouidb.git
PKG_SOURCE_VERSION:=bab7b1810ce7fad9a84263b279267da6190caad9

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_BUILD_DEPENDS:=xsltproc

include $(INCLUDE_DIR)/package.mk

define Package/ouidb
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=OUI database
  DEPENDS:=+sqlite3-cli
endef

define Build/Compile
	make
endef

define Package/ouidb/install
	make PREFIX=/usr DESTDIR=$(1) install
endef

$(eval $(call BuildPackage,ouidb))
