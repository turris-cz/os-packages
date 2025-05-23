#
## Copyright (C) 2018-2021 CZ.NIC z.s.p.o. (https://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel-minipot
PKG_VERSION:=2.3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/sentinel/minipot.git
PKG_MIRROR_HASH:=01f6ff3e95c277c692aba589718cd8eafc44c3a6304cd402df7b37d2bdb14592
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=argp-standalone gperf/host

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/sentinel-minipot
  SECTION:=collect
  CATEGORY:=Collect
  SUBMENU:=Sentinel
  TITLE:=Minipots
  URL:=https://gitlab.nic.cz/turris/sentinel/minipot
  DEPENDS:=\
    +czmq \
    +libevent2 \
    +logc \
    +logc-argp \
    +logc-czmq \
    +logc-libevent \
    +msgpack-c \
    +base64c \
    +sentinel-proxy
endef

define Package/sentinel-minipot/description
  Sentinel minipots. These are minimal honeypots.
  Implements protocols: FTP, HTTP, SMTP submission and Telnet
endef

define Package/sentinel-minipot/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sentinel-minipot $(1)/usr/bin/sentinel-minipot

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/init $(1)/etc/init.d/sentinel-minipot

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-sentinel-minipot-telnet

	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/sentinel-firewall.sh $(1)/usr/libexec/sentinel/firewall.d/70-minipot.sh
	$(INSTALL_DATA) ./files/defaults.sh $(1)/usr/libexec/sentinel/minipot-defaults.sh

	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/reload_hooks.d
	$(INSTALL_BIN) ./files/restart-minipot-hook.sh $(1)/usr/libexec/sentinel/reload_hooks.d/60_minipot.sh

	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/status.d
	$(INSTALL_BIN) ./files/sentinel-status.sh $(1)/usr/libexec/sentinel/status.d/21-minipots.sh
endef

$(eval $(call BuildPackage,sentinel-minipot))
