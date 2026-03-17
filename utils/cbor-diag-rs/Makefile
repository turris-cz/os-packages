PKG_NAME:=cbor-diag-rs
PKG_VERSION:=0.1.12
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/Nullus157/cbor-diag-rs/tar.gz/cbor-diag-$(PKG_VERSION)?
PKG_HASH:=4fdf7d28e1d76899585631eec35a9b6f4153874a06c58013650a23b70b4dd735

PKG_MAINTAINER:=CZ.NIC <packaging@turris.cz>
PKG_LICENSE:=MIT OR Apache-2.0
PKG_LICENSE_FILES:=LICENSE-APACHE LICENSE-MIT

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include ../../lang/rust/rust-package.mk

define Package/cbor-diag-rs
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=cbor-diag-rs
  DEPENDS:=$(RUST_ARCH_DEPENDS)
  URL:=https://github.com/Nullus157/cbor-diag-rs
endef

define Package/cbor-diag-rs/description
  A crate for parsing data encoded in Concise Binary Object Representation (CBOR)
  (in any of raw binary, hex encoded (with comments) or diagnostic notation)
  then printing it out in either annotated hex form or diagnostic notation. 
  While doing so as much of the structured data as possible is retained to
  improve the debugging experience. The primary intention of this crate is to be
  used in diagnostic tools working with CBOR data.
endef

$(eval $(call RustBinPackage,cbor-diag-cli))
$(eval $(call BuildPackage,cbor-diag-rs))
