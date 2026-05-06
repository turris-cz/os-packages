#
# Copyright © 2026 CZ.NIC z.s.p.o.
#
# This is free software, licensed under the GNU General Public Licensse v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ouidb
PKG_VERSION:=20250506
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/ouidb.git
PKG_SOURCE_VERSION:=3f543a49d2baaf1ab99d0061ef6548c388ca0c7a

PKG_BUILD_DEPENDS:=scdoc/host
# also: curl cmd(sqlite3)

include $(INCLUDE_DIR)/package.mk

MAKE_FLAGS+=PREFIX="/usr"

define Package/ouidb
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=OUI database and lookup tool
	URL:=https://gitlab.nic.cz/turris/ouidb
	DEPENDS:=+sqlite3-cli
endef

define Package/ouidb/description
	OUI database and lookup tool
endef

define Package/ouidb/install
	$(MAKE) -C $(PKG_BUILD_DIR) PREFIX="/usr" DESTDIR="$(1)" install
endef

$(eval $(call BuildPackage,ouidb))
