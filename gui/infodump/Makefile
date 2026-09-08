#
# Copyright (C) 2026 CZ.NIC, z.s.p.o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=infodump
PKG_VERSION:=0.1
PKG_RELEASE:=2026-09-09

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.nic.cz/turris/display/infodump.git
PKG_SOURCE_VERSION:=0ff5827f4530ff2fd11701adc6a674dde42adab5

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_DIR:=$(BUILD_DIR)/infodump-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

export CARGO_NET_GIT_FETCH_WITH_CLI:=true

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

CARGO_PKG_PROFILE:=release

define Package/infodump
  SECTION:=gui
  CATEGORY:=GUI Applications
  TITLE:=Simple diagnostics program with hardware detection
  DEPENDS:=$(RUST_ARCH_DEPENDS) +libwayland +xkeyboard-config +peacomp +libsqlite3 +turris-hwdb
  URL:=https://gitlab.nic.cz/turris/display/infodump
endef

define Package/infodump/description
	Simple diagnostics program
endef

define Package/infodump/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUSTC_TARGET_ARCH)/release/infodump $(1)/usr/bin/turris-infodump

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/infodump.init $(1)/etc/init.d/turris-infodump

	$(INSTALL_DIR) $(1)/etc/hotplug.d/button/
	$(INSTALL_BIN) ./files/infodump.hotplug $(1)/etc/hotplug.d/button/30-factory-infodump
endef

define Package/infodump/postinst
#!/bin/sh

if [ -n "$$IPKG_INSTROOT" ]; then
	"$$IPKG_INSTROOT/etc/rc.common" \
		"$$IPKG_INSTROOT/etc/init.d/turris-infodump" enable
else
	/etc/init.d/turris-infodump enable
fi
endef

$(eval $(call RustBinPackage,infodump))
$(eval $(call BuildPackage,infodump))
