#
## Copyright (C) 2018-2025 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=turris-translations
PKG_VERSION:=1.7.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/turris-translations.git
PKG_MIRROR_HASH:=2dd14394193750bd8deb2d231be4925116f0e9e62a327ffcf368ae8fe335c2f4
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_BUILD_DEPENDS:=gettext-full

include $(INCLUDE_DIR)/package.mk

Build/Compile:=:

# This is meta package for translations for multiple other smaller packages.
# So this generates multiple other packages. Call and evaluate following define
# where first argument has to be a name of package and template at the same time
# and second argument has to be a supported language codes.

define TRANSLATION_LANG

define Package/$(1)-l10n-$(2)
  TITLE:=Translation for package $(1): $(2)
  DEPENDS:=+$(1)
endef

define Package/$(1)-l10n-$(2)/install
	$(MAKE) -C $(PKG_BUILD_DIR) DESTDIR="$$(1)" install-$(1)-$(2)
endef

$$(eval $$(call BuildPackage,$(1)-l10n-$(2)))
endef

define TRANSLATION
$$(foreach LANG,$(2),$$(eval $$(call TRANSLATION_LANG,$(1),$$(LANG))))
endef

$(eval $(call TRANSLATION,pkglists,cs da de el es fi fo fr hr hu it ja ko lt nb_NO nl pl ro ru sk sv))
$(eval $(call TRANSLATION,user-notify,cs da de el es fi fo fr hr hu it ja ko lt nb_NO nl pl ro ru sk sv tr))
