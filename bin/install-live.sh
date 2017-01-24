#!/bin/bash

BUILD_TOOLS=/root/build
LIVE_MNT=/tmp/live

TARGET=/root/build/live-build
INSTALLER=${BUILD_TOOLS}/kali2-build
TRD=${BUILD_TOOLS}/3rdparty

TMP_INSTALLER=/tmp/installer
TMP_3RD=/tmp/3rdparty

MNAME=live

mkdir -p ${TARGET}
mkdir -p ${TARGET}/${TMP_INSTALLER}
mkdir -p ${TARGET}/${TMP_3RD}

debootstrap stable ${TARGET}
systemd-nspawn -D ${TARGET} --bind-ro=${INSTALLER}:${TMP_INSTALLER} /usr/bin/debconf-set-selections ${TMP_INSTALLER}/etc/debconf-live.cfg
systemd-nspawn -D ${TARGET} --setenv=DEBIAN_FRONTEND=noninteractive /usr/bin/tasksel --new-install install standard

systemd-nspawn -D ${TARGET} -M ${MNAME} --bind=/tmp/.X11-unix:/tmp/.X11-unix --bind-ro=${INSTALLER}:${TMP_INSTALLER} --bind-ro=${TRD}:${TMP_3RD} /bin/bash ${TMP_INSTALLER}/bin/install-local-live.sh

rmdir ${TARGET}/${TMP_INSTALLER}
rmdir ${TARGET}/${TMP_3RD}

cp ${TARGET}/boot/vmlinuz* ${LIVE_MNT}/live/vmlinuz
cp ${TARGET}/boot/initrd.img* ${LIVE_MNT}/live/initrd.img

mksquashfs ${TARGET} ${LIVE_MNT}/live/filesystem.squashfs

#systemd-nspawn -D ${TARGET} -M ${MNAME} --bind=/tmp/.X11-unix:/tmp/.X11-unix --bind-ro=${INSTALLER}:${TMP_INSTALLER} --bind-ro=${TRD}:${TMP_3RD} /bin/bash

