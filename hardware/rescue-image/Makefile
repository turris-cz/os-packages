#
## Copyright (C) 2016 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
## This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# #
#
include $(TOPDIR)/rules.mk

PKG_NAME:=rescue-image
PKG_VERSION:=3.6.1
PKG_RELEASE:=$(AUTORELEASE)
BB_VERSION:=1.33.2
PKG_SOURCE:=busybox-$(BB_VERSION).tar.bz2
PKG_SOURCE_URL:=https://www.busybox.net/downloads \
		http://sources.buildroot.net
PKG_HASH:=6843ba7977081e735fa0fdb05893e3c002c8c5ad7c9c80da206e603cc0ac47e7
PKG_MAINTAINER:=Michal Hrusecky <michal.hrusecky@nic.cz>
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
ROOTFS_INSTALL:=+libgcc +libc +kernel \
				+kmod-crypto-hash +kmod-crypto-crc32c +kmod-lib-crc32c +kmod-crypto-acompress +kmod-lib-lzo +kmod-lib-zlib-inflate +kmod-lib-zlib-deflate \
				+kmod-lib-raid6 +kmod-lib-xor +kmod-lib-xxhash +kmod-lib-zstd +kmod-crypto-blake2b +kmod-crypto-xxhash +kmod-fs-btrfs \
				+libubox +mtd +libpthread +librt +libattr +libuuid +zlib +libblkid +liblzo +libmount +uboot-envtools \
				+btrfs-progs +libsmartcols +mount-utils +schnapps +dropbear +usign +cert-backup-btrfs +cert-backup +cznic-repo-keys +libopenssl +libpcre2 +wget-ssl +libhavege +haveged \
				+kmod-nls-base +kmod-usb-core +kmod-scsi-core +kmod-usb-storage +kmod-usb-storage-extras +kmod-usb-storage-uas \
				+kmod-fs-exfat +kmod-lib-crc16 +kmod-fs-ext4 +kmod-nls-cp437 +kmod-nls-iso8859-1 +kmod-nls-utf8 +kmod-fs-vfat
PKG_BUILD_DEPENDS:=opkg/host mtd btrfs-progs schnapps wget cznic-repo-keys usign dropbear haveged uboot-tools kernel

include $(INCLUDE_DIR)/target.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

ifeq ($(CONFIG_TARGET_mvebu_cortexa53_DEVICE_cznic_turris-mox),y)
DEVICE := mox
else ifeq ($(CONFIG_TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia),y)
DEVICE := omnia
else ifeq ($(CONFIG_TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng),y)
DEVICE := omnia-ng
ROOTFS_INSTALL+=+kmod-qca-nss-phy +kmod-qca-ssdk \
				+kmod-hwmon-core +kmod-qca8k-cc +kmod-qca8084 +kmod-qca81xx +kmod-qca8xxx-phc \
				+kmod-lib-crc-ccitt +kmod-slhc +kmod-ppp +kmod-iptunnel +kmod-gre +kmod-pppox +kmod-pptp \
				+kmod-nf-conntrack +kmod-nf-conntrack6 +kmod-nat46 +kmod-qca-nss-ppe +kmod-qca-nss-dp +kmod-qca-nss-drv-lite \
				+kmod-input-core +kmod-nls-base +kmod-input-gpio-keys +kmod-input-evdev +kmod-usb-dwc3 +kmod-usb-dwc3-qcom
PKG_BUILD_DEPENDS+=kmod-qca-nss-drv-lite
else
DEVICE := unknown
endif

define Package/rescue-image
	TITLE:=rescue-image
	DEPENDS:=@(TARGET_mvebu_cortexa53_DEVICE_cznic_turris-mox||TARGET_mvebu_cortexa9_DEVICE_cznic_turris-omnia||TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng) $(ROOTFS_INSTALL)
endef

define Build/Prepare
	mkdir -p "$(PKG_BUILD_DIR)/rootfs/sbin"
	mkdir -p "$(PKG_BUILD_DIR)/rootfs/etc"
	mkdir -p "$(PKG_BUILD_DIR)/rootfs/lib"
	echo -e 'nameserver 193.17.47.1\nnameserver 2001:148f:ffff::1\nnameserver 185.43.135.1' > "$(PKG_BUILD_DIR)/rootfs/etc/resolv.conf"
	mkdir -p "$(PKG_BUILD_DIR)/rootfs/tmp"
	mkdir -p "$(PKG_BUILD_DIR)/rootfs/var/lock"
	mkdir -p "$(PKG_BUILD_DIR)/busybox"
	echo "Turris Rescue $(PKG_VERSION)-$(PKG_RELEASE)" > "$(PKG_BUILD_DIR)/rootfs/version"
	echo "root::0:0:root:/:/bin/sh" > "$(PKG_BUILD_DIR)/rootfs/etc/passwd"
	echo "/bin/sh" > "$(PKG_BUILD_DIR)/rootfs/etc/shells"
	$(INSTALL_BIN) ./files/helpers.sh "$(PKG_BUILD_DIR)/rootfs/lib/helpers.sh"
	$(INSTALL_BIN) ./files/board_helpers.sh "$(PKG_BUILD_DIR)/rootfs/lib/board_helpers.sh"
	$(INSTALL_BIN) ./files/rescue.sh "$(PKG_BUILD_DIR)/rootfs/init"
	$(INSTALL_BIN) ./files/$(DEVICE).sh "$(PKG_BUILD_DIR)/rootfs/lib/board.sh"
	$(HOST_TAR) -C $(PKG_BUILD_DIR)/busybox --strip-components=1 -xjf $(DL_DIR)/$(PKG_SOURCE)
	mkdir -p "$(PKG_BUILD_DIR)"/rootfs//usr/share/udhcpc
	cp "$(PKG_BUILD_DIR)"/busybox/examples/udhcp/simple.script "$(PKG_BUILD_DIR)"/rootfs//usr/share/udhcpc/default.script
	chmod a+rx "$(PKG_BUILD_DIR)"/rootfs//usr/share/udhcpc/default.script
	cp ./files/rootfs.extra "$(PKG_BUILD_DIR)/rootfs.extra"
	cp ./files/$(DEVICE).its "$(PKG_BUILD_DIR)/rescue.its"
endef

define Build/Configure
	sed -i 's|^BOARD=.*|BOARD=$(DEVICE)|' "$(PKG_BUILD_DIR)/rootfs/init"
	# Busybox
	cp files/busybox-config $(PKG_BUILD_DIR)/busybox/.config
	$(MAKE) -C "$(PKG_BUILD_DIR)/busybox" $(PKG_JOBS) $(MAKE_FLAGS) oldconfig
	sed -i \
		-e 's|./Image|$(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/Image|' \
		-e 's|./dts|$(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/dts|' \
		-e 's|./initrd|$(PKG_BUILD_DIR)/initrd.gz|' \
		"$(PKG_BUILD_DIR)/rescue.its"
endef

define Build/Compile
	rm -rf "$(PKG_BUILD_DIR)"/rootfs/usr/lib/opkg
	cd "$(PKG_BUILD_DIR)/busybox"; $(MAKE) $(PKG_JOBS) -C "$(PKG_BUILD_DIR)/busybox" \
		$(MAKE_FLAGS) CONFIG_PREFIX="$(PKG_BUILD_DIR)/rootfs" all install
	export IPKG_NO_SCRIPT=1;\
	export IPKG_INSTROOT="$(PKG_BUILD_DIR)/rootfs"; \
	export TMPDIR="$(PKG_BUILD_DIR)/rootfs/tmp"; \
	mkdir -p "$(PKG_BUILD_DIR)/rootfs/usr/lib/opkg/info"
	echo -e "Package: tar\nVersion: 1.35-r1\nDepends: libc\nStatus: install user installed\nArchitecture: $(PKGARCH)\nInstalled-Time: 0\n\n" > "$(PKG_BUILD_DIR)/rootfs/usr/lib/opkg"/status
	touch "$(PKG_BUILD_DIR)"/rootfs/usr/lib/opkg/info/tar.list
	for pkg in $(ROOTFS_INSTALL); do\
		PKG_FILE="`echo $$$$pkg | sed 's|^+||'`_*_$(PKGARCH).ipk"; \
		PKG="`find $(OUTPUT_DIR) -name "$$$$PKG_FILE" -print`"; \
		[ -n "$$$$PKG" ] || { echo "$$$$PKG_FILE is missing!"; exit 1; }; \
		$(STAGING_DIR_HOST)/bin/opkg --offline-root "$(PKG_BUILD_DIR)/rootfs" --force-depends install --force-depends "$$$$PKG" ;\
	done
	rm -rf "$(PKG_BUILD_DIR)/rootfs"/usr/lib/opkg
	rm -rf "$(PKG_BUILD_DIR)/rootfs"/boot
ifeq ($(CONFIG_TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng),y)
	mkdir -p "$(PKG_BUILD_DIR)/rootfs/usr/share/rescue"
	for i in files/imgs/*.png; do convert $$$$i -depth 8 bgra:"$(PKG_BUILD_DIR)/rootfs/usr/share/rescue"/`basename $$$$i .png`.rgb; done
endif
	cd $(LINUX_DIR); ./usr/gen_initramfs.sh \
	-o "$(PKG_BUILD_DIR)"/initrd.gz -u squash -g squash \
	"$(PKG_BUILD_DIR)/rootfs" "$(PKG_BUILD_DIR)/rootfs.extra"
endef

define Package/rescue-image/install
	install -d $(1)/usr/share/rescue-image
	PATH="$(LINUX_DIR)/scripts/dtc:$$PATH" \
	"$(STAGING_DIR_HOST)"/bin/mkimage -f "$(PKG_BUILD_DIR)"/rescue.its $(1)/usr/share/rescue-image/image.fit
	xz -k9 -F lzma $(1)/usr/share/rescue-image/image.fit
ifeq ($(CONFIG_TARGET_ipq95xx_generic_DEVICE_cznic_turris-omnia-ng),y)
	[ "`stat -c '%s' $(1)/usr/share/rescue-image/image.fit.lzma`" -lt 12386304 ]
else
	[ "`stat -c '%s' $(1)/usr/share/rescue-image/image.fit.lzma`" -lt 7340032 ]
endif
	[ "`stat -c '%s' $(1)/usr/share/rescue-image/image.fit.lzma`" -gt 1000000 ]
endef

$(eval $(call BuildPackage,rescue-image))
