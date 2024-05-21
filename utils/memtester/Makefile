#
# Copyright (C) 2024 Marek Behún <kabel@kernel.org>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=memtester
PKG_VERSION:=4.6.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://pyropus.ca./software/memtester/old-versions/
PKG_HASH:=c9fe4eb7e80c8cef5202f9065c4c0682f5616647c0455e916a5700f98e3dbb2e

include $(INCLUDE_DIR)/package.mk

define Package/memtester
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Userspace utility for testing the memory subsystem for faults
  URL:=http://pyropus.ca/software/memtester/
endef

define Package/memtester/description
  Userspace utility for testing the memory subsystem for faults.
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) \
		-DPOSIX -D_POSIX_C_SOURCE=200809L \
		-D_FILE_OFFSET_BITS=64 -DTEST_NARROW_WRITES \
		-o $(PKG_BUILD_DIR)/memtester \
		$(PKG_BUILD_DIR)/memtester.c $(PKG_BUILD_DIR)/tests.c
endef

define Package/memtester/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/memtester $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,memtester))
