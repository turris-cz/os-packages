#
## Copyright (C) 2020, 2022 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel-fwlogs
PKG_VERSION:=0.3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://gitlab.nic.cz/api/v4/projects/976/packages/generic/sentinel-fwlogs/$(PKG_VERSION)
PKG_HASH:=e9df14ac2d2fef15b02a6291f0a580e998b74c9a5fe1c85cb6becbcbc167c8c7

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=argp-standalone

PKG_INSTALL:=1

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/autotools.mk

define Package/sentinel-fwlogs
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=FWLogs
  URL:=https://gitlab.nic.cz/turris/sentinel/fwlogs
  DEPENDS:=\
    +czmq \
    +kmod-ipt-nflog \
    +msgpack-c \
    +logc +logc-argp +logc-czmq \
    +libnetfilter-log \
    +sentinel-fwlogs-integration \
    +sentinel-proxy
  PROVIDES:=sentinel-nikola
  CONFLICTS:=sentinel-nikola
endef

define Package/sentinel-fwlogs/description
  Collector of firewall logs using libnetfilter-log for Turris Sentinel.
endef

define Package/sentinel-fwlogs-iptables-integration
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=FWLogs iptables integration
  URL:=https://gitlab.nic.cz/turris/sentinel/fwlogs
  DEPENDS:=+firewall +iptables-mod-nflog
  PROVIDES:=sentinel-fwlogs-integration
  CONFLICTS:=sentinel-fwlogs-nftables-integration
endef

define Package/sentinel-fwlogs-iptables-integration/description
  Collector of firewall logs using libnetfilter-log for Turris Sentinel.

  This package provides integrations into Firewall3 base on iptables.
endef

define Package/sentinel-fwlogs-nftables-integration
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=FWLogs nftables integration
  URL:=https://gitlab.nic.cz/turris/sentinel/fwlogs
  DEPENDS:=+firewall4
  PROVIDES:=sentinel-fwlogs-integration
  CONFLICTS:=sentinel-fwlogs-iptables-integration
endef

define Package/sentinel-fwlogs-nftables-integration/description
  Collector of firewall logs using libnetfilter-log for Turris Sentinel.

  This package provides integrations into Firewall4 base on nftables.
endef

define Package/sentinel-fwlogs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sentinel-fwlogs $(1)/usr/bin/sentinel-fwlogs

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/init $(1)/etc/init.d/sentinel-fwlogs

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-sentinel-fwlogs

	$(INSTALL_DIR) $(1)/usr/libexec/sentinel
	$(INSTALL_DATA) ./files/defaults.sh $(1)/usr/libexec/sentinel/fwlogs-defaults.sh

	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/reload_hooks.d
	$(INSTALL_BIN) ./files/restart-proxy-hook.sh $(1)/usr/libexec/sentinel/reload_hooks.d/50_nikola.sh

	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/status.d
	$(INSTALL_BIN) ./files/sentinel-status.sh $(1)/usr/libexec/sentinel/status.d/20-fwlogs.sh
endef

define Package/sentinel-fwlogs-iptables-integration/install
	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/sentinel-firewall-iptables.sh $(1)/usr/libexec/sentinel/firewall.d/60-fwlogs.sh
endef

define Package/sentinel-fwlogs-nftables-integration/install
	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/sentinel-firewall-nftables.sh $(1)/usr/libexec/sentinel/firewall.d/60-fwlogs.sh
endef

$(eval $(call BuildPackage,sentinel-fwlogs))
$(eval $(call BuildPackage,sentinel-fwlogs-iptables-integration))
$(eval $(call BuildPackage,sentinel-fwlogs-nftables-integration))
