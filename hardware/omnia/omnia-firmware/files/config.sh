UBOOT_PART="mtd0"
RESCUE_PART="mtd1"
UBOOT_DEVEL="/usr/share/omnia/uboot-devel"

board_ubootenv_hook() {
    sed -i 's|btr\(load[[:blank:]]\+[^[:blank:]]\+[[:blank:]]\+[^[:blank:]]\+[[:blank:]]\+[^[:blank:]]\+[[:blank:]]\+\)\([^[:blank:]]\+\)[[:blank:]]\+\([^[:blank:];]\+\)|\1\3/\2|g' \
        "$BACKUP_UBOOT_ENV"
    if grep -q 'U-Boot 2015.10-rc2' /dev/mtd0; then
        omnia-eeprom set ddr_speed 1333H
    fi
}
