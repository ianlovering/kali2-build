#!/bin/bash

TARGET=$1
NAME_PREFIX=kali2_${TARGET}

CRYPT_NAME=crypt-main

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

if ! [ "x${DISK}" == "x0" ]; then
	if blkid $DEV | grep -q crypt; then
		
		get_input "Enter Key" "Enter the encryption key for the partition\n\n"
		KEY=$input
		CRYPT=$DEV
		open_crypt $CRYPT $KEY $CRYPT_NAME
		vgchange -ay
		select_volume "Select Target" "Select the volume to use:" 
		ROOT=$result
		select_volume "Select Swap Volume" "Select the volume to use:"
		SWAP=$result
		select_part  "Select Boot Partition" "Select boot partition\n" 
		BOOT=$result
	else
		ROOT=$DEV
		select_part  "Select Swap Partition" "Select swap partition\n" 
		SWAP=$result
	fi
	
	DISK_DEV=$(echo $DEV | sed 's/[0-9]//g')
fi 
	
#if check size $MIN_SIZE ${DEV}

if [ "x${DISK}" == "x0" ]; then
	ask_yes_no "Continue?" "The following disks will be overwritten\n\n$DEV\n\n"
else
	ask_yes_no "Continue?" "The following partitions/volumes will be overwritten\n\n$ROOT\n$BOOT\n$SWAP\n"
fi

if ! [ "x${result}" == "x0" ]; then
	abort
fi

if [ "x${DISK}" == "x0" ]; then
	ROOT=/dev/mapper/main-root
	SWAP=/dev/mapper/main-swap
	VGROUP=main

	DISK_DEV=$DEV
	partition_disk $DEV

	BOOT=${DEV}2
	CRYPT=${DEV}3
	KEY=$(apg -n 1 -m 12 -x 12 -M LN)

	create_crypt $CRYPT $KEY
	open_crypt $CRYPT $KEY $CRYPT_NAME
	create_volumes /dev/mapper/${CRYPT_NAME} $VGROUP
	vgchange -ay
fi

mkswap ${SWAP}

gunzip -c ${IMAGES_MNT}/${IMAGE_FILE} | partclone.ext4 -r -o ${ROOT}
resize2fs ${ROOT}

mkdir -p ${ROOT_TARGET}
mount ${ROOT} ${ROOT_TARGET}

if [[ ! -z $CRYPT ]]; then
	mkfs.ext4 -F ${BOOT}
	mkdir -p ${BOOT_TARGET}
	mount ${BOOT} ${BOOT_TARGET}
	
	mv ${ROOT_TARGET}/boot/* ${BOOT_TARGET}
	umount ${BOOT_TARGET}

	cp 99boot ${ROOT_TARGET}/etc/apt/apt.conf.d/
	
	update_fstab ${ROOT_TARGET} ${SWAP} ${BOOT}
	update_crypttab ${ROOT_TARGET} ${CRYPT} ${CRYPT_NAME}
	umount ${ROOT_TARGET}
	vgchange -an
	close_crypt $CRYPT_NAME
	
	open_crypt $CRYPT $KEY $CRYPT_NAME
	vgchange -ay
	mount ${ROOT} ${ROOT_TARGET}
	mount ${BOOT} ${ROOT_TARGET}/boot

else
	update_fstab ${ROOT_TARGET} ${SWAP}
fi

mount_chroot_dynamic ${ROOT_TARGET}

chroot ${ROOT_TARGET} <<EOF
update-initramfs -u
update-grub
grub-install $DISK_DEV
EOF
	
umount_chroot_dynamic ${ROOT_TARGET}

if [[ ! -z $CRYPT ]]; then
	umount ${ROOT_TARGET}/boot
fi

setup_restore2 ${ROOT_TARGET} ${TARGET}
umount ${ROOT_TARGET}

if [[ ! -z $CRYPT ]]; then
	vgchange -an
	close_crypt $CRYPT_NAME
	
	if [ "x${DISK}" == "x0" ]; then
		show_message "Encryption Key" "\n${KEY}\n"
	fi
fi
	
#setup stage 2
#reboot
shutdown -r now

