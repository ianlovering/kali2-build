#!/bin/bash

set -e

rootdir=$1

. /usr/share/vmdebootstrap/common/customise.lib

trap cleanup 0

mount_support
disable_daemons

MY_PACKAGES="gdisk parted partclone cryptsetup cifs-utils lvm2 wget apg"

chroot ${rootdir} apt-get -y install initramfs-tools live-boot live-config live-config-systemd ${MY_PACKAGES} task-laptop task-english
mkdir -p ${rootdir}/etc/systemd/system/getty@tty1.service.d
cp autologin.conf ${rootdir}/etc/systemd/system/getty@tty1.service.d

echo "blacklist bochs-drm" > ${rootdir}/etc/modprobe.d/qemu-blacklist.conf

