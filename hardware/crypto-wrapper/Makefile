#
## Copyright (C) 2019-2024 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=crypto-wrapper
PKG_VERSION:=0.5
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/crypto-wrapper.git
PKG_MIRROR_HASH:=0dd32c997b4034c47ecab31628d4de57c07df553dbf873f6cfc869b8bd267a86
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE.md

include $(INCLUDE_DIR)/package.mk

define Package/crypto-wrapper
  TITLE:=Crypto Wrapper CLI
  DEPENDS:=\
    +TARGET_mpc85xx_p2020_DEVICE_cznic_turris1x:libatsha204 \
    +TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia:libatsha204 +TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia:omnia-mcutool \
    +TARGET_mvebu_cortexa53_DEVICE_cznic_turris-mox:mox-otp \
	+TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng:omnia-ng-crypto
endef

define Package/crypto-wrapper/description
  Tool to unify interface for cryptographic entities on Turris 1.x, Omnia and MOX
endef

Build/Compile:=:

define Package/crypto-wrapper/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/crypto-wrapper.sh $(1)/usr/bin/crypto-wrapper
endef

$(eval $(call BuildPackage,crypto-wrapper))
