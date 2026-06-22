#
# Copyright (C) 2026 CZ.NIC z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reforis-tailscale-plugin
PKG_VERSION:=0.1.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/reforis/reforis-tailscale
PKG_MIRROR_HASH:=a217b8461ec73b027cf139c999a86f806a17a226dc3c81d350560a4cf16ceecb
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=node/host hatch-reforis/host

PYTHON3_PKG_WHEEL_NAME:=reforis_tailscale

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include ../reforis/files/reforis-plugin.mk
include ../reforis/files/reforis-translations.mk

define Package/reforis-tailscale-plugin
  SECTION:=web
  CATEGORY:=Web
  SUBMENU:=reForis
  TITLE:=reForis Tailscale plugin
  URL:=https://gitlab.nic.cz/turris/reforis/reforis-tailscale-plugin
  DEPENDS:=\
    +reforis \
    +tailscale \
    +foris-controller-tailscale-module
endef

define Package/reforis-tailscale-plugin/description
  reForis Tailscale plugin allows users to configure Tailscale VPN on their Turris router using the reForis web interface.
endef

define Package/reforis-tailscale-plugin/postinst
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
	/etc/init.d/tailscale enable
	/etc/init.d/tailscale restart
fi
endef

REFORIS_TRANSLATIONS:=cs

$(eval $(call ReForisPlugin,reforis-tailscale-plugin,reforis_tailscale))
# call BuildPackage <= assures OWR build system that this is package
