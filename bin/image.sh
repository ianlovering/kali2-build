#!/bin/bash

TARGET_MAIN=/dev/sdb2
TARGET_SWAP=/dev/sdb3
TARGET_EFI=/dev/sdb4

SOURCE_MAIN=/dev/sda1
BOOT_DISK=/de/sdb

TARGET_MNT=/mnt/target

INSTALL=./
TMP_INSTALLER=/tmp/installer

partclone.ext4 -b -s ${SOURCE_MAIN} -o ${TARGET_MAIN}

mkdir ${TARGET_MNT}
mount ${TARGET_MAIN} ${TARGET_MNT}

systemd-run systemd-nspawn -M target --bind-ro ${INSTALL}:${TMP_INSTALLER} -D ${TARGET_MNT} -b

sleep 5
systemd-run -M target bash ${TMP_INSTALLER}/bin/make-boot.sh ${BOOT_DISK} ${TARGET_MAIN} ${TARGET_SWAP} ${TARGET_EFI}

