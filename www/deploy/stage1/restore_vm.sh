#!/bin/bash

TARGET=$1
NAME_PREFIX=kali2_${TARGET}

BOOT_TARGET=/mnt/boot
ROOT_TARGET=/mnt/root

source restore_functions.sh
source restore_config.sh

mkdir -p ${IMAGES_MNT}
while ! mount | grep -q "${IMAGES_MNT}"; do
	sleep 2
	mount -o username=${SMB_USER},password=${SMB_PASS} -t cifs ${SMB_SHARE} ${IMAGES_MNT}
done

select_image ${IMAGES_MNT}
IMAGE_FILE=$result

select_target
DEV=$result

is_disk $DEV
DISK=$result

#if check size $MIN_SIZE ${DEV}

ask_yes_no "Continue?" "The following disks will be overwritten\n\n$DEV\n\n"

if ! [ "x${result}" == "x0" ]; then
	abort
fi

DISK_DEV=$DEV
ROOT=${DISK_DEV}3
SWAP=${DISK_DEV}2
partition_disk_nocrypt $DISK_DEV

mkswap ${SWAP}

gunzip -c ${IMAGES_MNT}/${IMAGE_FILE} | partclone.ext4 -r -o ${ROOT}
resize2fs ${ROOT}

mkdir -p ${ROOT_TARGET}
mount ${ROOT} ${ROOT_TARGET}

update_fstab ${ROOT_TARGET} ${SWAP}

mount_chroot_dynamic ${ROOT_TARGET}

chroot ${ROOT_TARGET} <<EOF
update-initramfs -u
update-grub
grub-install $DISK_DEV
EOF
	
umount_chroot_dynamic ${ROOT_TARGET}

setup_restore2 ${ROOT_TARGET} ${TARGET}
umount ${ROOT_TARGET}

#setup stage 2
#reboot
shutdown -r now

