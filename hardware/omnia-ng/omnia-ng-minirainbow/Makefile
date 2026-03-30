include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=omnia-ng-minirainbow
PKG_VERSION:=1.5
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/packages
PKG_BUILD_DEPENDS:=linux

include $(INCLUDE_DIR)/package.mk

define Package/omnia-ng-minirainbow
  TITLE:=Turris Omnia NG Minirainbow
  VERSION:=$(LINUX_VERSION)-$(LINUX_RELEASE)-$(LINUX_VERMAGIC)
  RELEASE:=$(PKG_VERSION)-$(PKG_RELEASE)
  DEPENDS:=@TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng +kmod-gpio-button-hotplug
endef

define Package/omnia-ng-minirainbow/description
  Sets LED colors based on network status and dims LEDs based on\
  button input
endef

Build/Compile:=:

define Package/omnia-ng-minirainbow/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/minirainbow/minirainbow.init "$(1)"/etc/init.d/minirainbow
	$(INSTALL_BIN) ./files/minirainbow/minirainbow-boot.init "$(1)"/etc/init.d/minirainbow-boot
	$(INSTALL_DIR) $(1)/usr/libexec/minirainbow
	$(INSTALL_BIN) ./files/minirainbow/minirainbow.sh "$(1)"/usr/libexec/minirainbow/
	$(INSTALL_DIR) $(1)/usr/libexec/minirainbow
	$(INSTALL_BIN) ./files/minirainbow/set_brightness.sh "$(1)"/usr/libexec/minirainbow/
	$(INSTALL_DIR) $(1)/etc/hotplug.d/button/
	$(INSTALL_BIN) ./files/button/lights_toggle "$(1)"/etc/hotplug.d/button
endef

$(eval $(call BuildPackage,omnia-ng-minirainbow))
