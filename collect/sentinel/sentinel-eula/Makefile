#
## Copyright (C) 2019-2023 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel-eula
PKG_VERSION:=1.1.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/sentinel/eula.git
PKG_MIRROR_HASH:=d92db4dd614cb158fbd2165dfe89e6afea4cd9bcdea5b0da0157e98bd5231435
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE.md

include $(INCLUDE_DIR)/package.mk

define Package/sentinel-eula
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=Sentinel EULA
  URL:=https://gitlab.nic.cz/turris/sentinel/eula
endef

define Package/sentinel-eula/description
  Package containing EULAs for sentinel
endef

define Package/sentinel-eula/install
	$(call Build/Install/Default)
	$(INSTALL_DIR) $(1)/usr/share/sentinel-eula/
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/usr/share/sentinel-eula/
endef

$(eval $(call BuildPackage,sentinel-eula))
