#!/bin/sh

FW_PATH=/lib/firmware/ath12k/QCN92XX/hw1.0
SRC_PATH=/usr/libexec/wifi-detect

wakeup() {
    i2ctransfer -y -f 4 w5@0x51 0x10 0x00 0x00 0x00 0x00 >/dev/null 2>&1
    i2ctransfer -y 4 r4@0x60 >/dev/null 2>&1
}

hw_detect_new() {
	wakeup
	i2ctransfer -y 4 w8@0x60 0x03 0x07 0x02 0x00 0x15 0x00 0x17 0x5d
	# delay
	seq 100000 >/dev/null
	res=$(i2ctransfer -y 4 r4@0x60)

	if [ "${res:5:4}" = '0xaa' ]; then
		return 0
	else
		return 1
	fi
}

sn_detect_new() {
	SN="$(/usr/bin/crypto-wrapper serial-number)"
	[ -z "$SN" ] && return 1
	grep -q "$SN" < "${SRC_PATH}/SN.txt"
}

if hw_detect_new || sn_detect_new; then
	echo 'firmware detect: new'
	cp ${SRC_PATH}/board-2.bin.new "${FW_PATH}/board-2.bin"
else
	echo 'firmware detect: old'
	cp ${SRC_PATH}/board-2.bin.old "${FW_PATH}/board-2.bin"
fi

rm -rf "$SRC_PATH"
