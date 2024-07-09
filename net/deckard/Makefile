#
# Copyright (C) 2020-2024 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=deckard
PKG_VERSION:=3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/knot/deckard
PKG_SOURCE_VERSION:=b5b338678d48a9807097000afe03ebfdf705f7a3
PKG_MIRROR_HASH:=81d4740bb05e296565ee7b25f57f00f8a86f300d75af4c71f6b22be2e9cfa227

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=BSD-2-Clause
PKG_LICENSE_FILES:=LICENSE

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/deckard
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DNS testing framework
  URL:=https://gitlab.nic.cz/knot/deckard
  DEPENDS:= \
	+python3 \
	+python3-dns \
	+python3-pytest \
	+python3-yaml
endef

define Package/deckard/description
  Deckard helps debug DNS issues on different network configurations.
endef

Build/Compile:=:
Build/Install:=:

SCRIPTS_DIR:=/usr/libexec/deckard

define Package/deckard/install
	$(INSTALL_DIR) $(1)/$(SCRIPTS_DIR)/tools
	$(INSTALL_DIR) $(1)/usr/bin

	$(CP) $(PKG_BUILD_DIR)/{configs,contrib,doc,pydnstest,sets,template,tests,tools} $(1)/$(SCRIPTS_DIR)/
	$(CP) $(PKG_BUILD_DIR)/{*.sh,*.py,*.txt,*.rst,*.ini} $(1)/$(SCRIPTS_DIR)/
	$(INSTALL_BIN) ./files/dns_test.sh $(1)/$(SCRIPTS_DIR)/tools/
endef

$(eval $(call BuildPackage,deckard))
