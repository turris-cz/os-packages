#
# Copyright © 2026 CZ.NIC z.s.p.o.
#
# This is free software, licensed under the GNU General Public Licensse v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=scdoc
PKG_VERSION:=1.11.4
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://git.sr.ht/~sircmpwn/scdoc/archive/
PKG_HASH:=e1a9c2000f855123a1a50c8f897073e0ee95fc41787431efe3864c2f1c2e7092

PKG_BUILD_DEPENDS:=scdoc/host

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

MAKE_FLAGS+=HOST_SCDOC="$(STAGING_DIR_HOST)/usr/bin/scdoc"

define Package/scdoc
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Tool for generation roff manual pages
	URL:=https://git.sr.ht/~sircmpwn/scdoc
endef

define Package/scdoc/description
	scdoc is a simple man page generator for POSIX systems written in C99.
endef

define Package/scdoc/install
	$(MAKE) -C $(PKG_BUILD_DIR) PREFIX="/usr" DESTDIR="$(1)" install
	rm -rf $(1)/usr/share/pkgconfig
endef

define Host/Install
	$(MAKE) -C $(HOST_BUILD_DIR) PREFIX="/usr" DESTDIR="$(STAGING_DIR_HOST)" install
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,scdoc))
