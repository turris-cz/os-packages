#
# Copyright (C) 2017-2021 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pyzmq
PKG_VERSION:=25.1.0
PKG_RELEASE:=$(AUTORELEASE)

PYPI_NAME:=pyzmq
PKG_HASH:=80c41023465d36280e801564a69cbfce8ae85ff79b080e1913f6e90481fb8957

PKG_BUILD_DEPENDS:=cython

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-zmq
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Python bindings for 0MQ
  URL:=https://github.com/zeromq/pyzmq
  DEPENDS:=+python3 +libzmq
endef

define Package/python3-zmq/description
  This package contains Python bindings for 0MQ.
  0MQ is a lightweight and fast messaging implementation.
endef

define prepare_pyzmq_setup
	$(CP) ./files/setup.cfg $(PKG_BUILD_DIR)/setup.cfg
endef

Hooks/Compile/Pre += prepare_pyzmq_setup

PYTHON3_PKG_SETUP_ARGS:=

$(eval $(call Py3Package,python3-zmq))
$(eval $(call BuildPackage,python3-zmq))
$(eval $(call BuildPackage,python3-zmq-src))
