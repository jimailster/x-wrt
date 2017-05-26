#!/bin/sh
# compress all images into a single small archive.
# requires tar before compress so all data is in single stream.

CompressDir() {
odir=$(pwd)
cd "$1"
rm -f xwrt*.tar
rm -f xwrt*.rar.tar
tar -cvf xwrt-squashfs-images.tar *squashfs*.bin *squashfs*.trx
#tar -cvf xwrt-jffs-images.tar *jffs*.bin *jffs*.trx
7z a xwrt-firmware-images.7z xwrt-*-images.tar
cd "$odir"
}

CompressDir "imgbuild/OpenWrt-ImageBuilder-Linux-i686/bin/default"
CompressDir "imgbuild/OpenWrt-ImageBuilder-Linux-i686/bin/micro"
CompressDir "imgbuild/OpenWrt-ImageBuilder-Linux-i686/bin/pppoe"
CompressDir "imgbuild/OpenWrt-ImageBuilder-Linux-i686/bin/pptp"

