include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=omnia-ng-support
PKG_VERSION:=1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/packages
PKG_BUILD_DEPENDS:=linux

include $(INCLUDE_DIR)/package.mk

define Package/omnia-ng-support
  TITLE:=Turris Omnia essential generic support
  VERSION:=$(LINUX_VERSION)-$(LINUX_RELEASE)-$(LINUX_VERMAGIC)
  RELEASE:=$(PKG_VERSION)-$(PKG_RELEASE)
  DEPENDS:=@TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng
endef

define Package/omnia-ng-support/description
  Contains supporting files for Turris Omnia NG.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

Build/Configure:=

define Build/Compile
	mkimage -T script -C none -n boot -d files/boot.txt "$(PKG_BUILD_DIR)"/boot.scr
	$(KERNEL_MAKE) Image dtbs
endef

define Package/omnia-ng-support/install
	$(INSTALL_DIR) $(1)/boot
	$(INSTALL_DATA) $(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/dts/qcom/ipq9574-turris-omnia-ng.dtb "$(1)"/boot
	$(INSTALL_DATA) "$(PKG_BUILD_DIR)"/boot.scr "$(1)"/boot/boot.scr
	ln -s boot/boot.scr "$(1)"/boot.scr
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/initial-setup "$(1)"/etc/init.d
endef

$(eval $(call BuildPackage,omnia-ng-support))
