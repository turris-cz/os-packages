#
# Copyright (C) 2026 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=foris-controller-tailscale-module
PKG_VERSION:=0.3.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/foris-controller/foris-controller-tailscale-module.git
PKG_MIRROR_HASH:=e7bc9b574f3d2f90af286932d5f60387ddbece3a52eb66d41f13d14bbaf7c3fb
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../foris-controller/files/foris-controller-module.mk

define Package/foris-controller-tailscale-module
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=Foris Controller
  TITLE:=Foris controller tailscale module
  DEPENDS:=\
    +foris-controller \
    +tailscale
endef

define Package/foris-controller-tailscale-module/description
  This is a tailscale module for foris-controller.
endef

$(eval $(call ForisControllerModule,foris-controller-tailscale-module))
# call BuildPackage <= assures OWR build system that this is package
