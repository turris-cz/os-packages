#!/bin/sh -e
if test -z "$1"; then echo "Usage: $0 size < u-boot-env.txt > u-boot-env.bin"; exit 1; fi
size=$1
tmpfile=`mktemp`
LC_ALL=C sort | tr '\n' '\000' > "$tmpfile"
truncate -s 8188 "$tmpfile"
crc=`crc32 "$tmpfile"`
echo $((0x$crc)) | LC_ALL=C awk '{ for (i = 0; i < 32; i += 8) printf "%c", and(rshift($1, 32-8-i), 255) }'
cat "$tmpfile"
rm -f "$tmpfile"
dd if=/dev/zero bs=$(($size-8192)) count=1 2>/dev/null
