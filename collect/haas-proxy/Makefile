#
# Copyright (C) 2017-2019 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=haas-proxy
PKG_VERSION:=2.0.2
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=proxy-v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://gitlab.nic.cz/haas/proxy/-/archive/v$(PKG_VERSION)/
PKG_HASH:=42bc51b8ef221516136987656c238b4b7132c3864fdc251ace8dddb91542c54a
PKG_BUILD_DIR:=$(BUILD_DIR)/proxy-v$(PKG_VERSION)

PKG_MAINTAINER:=CZ.NIC <packaging@nic.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/haas-proxy
  SECTION:=collect
  CATEGORY:=Collect
  TITLE:=Honeypot as a Service proxy
  URL:=https://haas.nic.cz
  DEPENDS:= \
    +python3-light \
	+python3-cachetools \
	+python3-bcrypt \
	+python3-requests \
	+python3-twisted \
	+python3-crypto \
	+python3-service-identity \
	+sshpass \
	+@KERNEL_CFS_BANDWIDTH
  CONFLICTS:=mitmproxy
endef

define Package/haas-proxy/description
  HaaS proxy application forwards incoming traffic from port 22 (commonly used for
  SSH) to the HaaS server, where Cowrie honeypot simulates a device and records
  executed commands.
endef

define Py3Package/haas-proxy/install
	$(INSTALL_DIR) $(1)/usr/libexec/
	$(INSTALL_BIN) ./files/haas-proxy-start $(1)/usr/libexec/haas-proxy-start
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/haas-proxy.init $(1)/etc/init.d/haas-proxy
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/haas.uci $(1)/etc/config/haas
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/uci-defaults $(1)/etc/uci-defaults/99-haas-proxy
	$(INSTALL_DIR) $(1)/usr/libexec/sentinel/firewall.d
	$(INSTALL_BIN) ./files/sentinel-firewall.sh $(1)/usr/libexec/sentinel/firewall.d/80-haas-proxy.sh
endef

define Package/haas-proxy/conffiles
/etc/config/haas
endef

$(eval $(call Py3Package,haas-proxy))
$(eval $(call BuildPackage,haas-proxy))
$(eval $(call BuildPackage,haas-proxy-src))
