#
## Copyright (C) 2023 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#

include $(TOPDIR)/rules.mk

PKG_LICENSE:=GPL-3.0
PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_VERSION:=1.0

LUCI_NAME:=luci-app-easybird
LUCI_TITLE:=LuCI Support for easy Bird2 configuration
LUCI_DEPENDS:=+luci-mod-admin-full +bird2 +bird2cl
LUCI_PKGARCH:=all
LUCI_DESCRIPTION:=Easy configuration of OSPF and Babel in LuCI using Bird.

define Package/luci-app-easybird/conffiles
/etc/config/easybird
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
