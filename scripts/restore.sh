#!/bin/bash -x

[ -d /sys/firmware/efi ] && BOOT=efi || BOOT=bios

IMAGES_MNT=${1}
BUILD=${2}

NAME_PREFIX=kali-rolling_

LVGROUP=main
LVSWAP=swap
LVROOT=root

CRYPT_NAME=crypt-main

ROOT_TARGET=/mnt/root
IMAGE_FOLDER=images

source restore_functions.sh
#source restore_config.sh

# select which image to install
select_image ${IMAGES_MNT}/${IMAGE_FOLDER}
IMAGE_FILE=$result

# select profile

# select type of install
# whole disk (unencrypted / luks / sed), existing filesystem
select_restore_type
restore_type=$result

if [ "x${restore_type}" == "xWDN" ] || [ "x${restore_type}" == "xWDL" ]; then

	# select the disk
	select_disk
	disk=$result
	ask_yes_no "Continue?" "The following disk will be overwritten\n\n$disk\n\n"
	if ! [ "x${result}" == "x0" ]; then
		abort
	fi	
	
	# setup sed encryption if required
	
	partition_disk $disk
	
	# setup luks encryption if required
	if [ "x${restore_type}" == "xWDL" ]; then

		KEY=$(apg -n 1 -m 12 -x 12 -M LN)
		CRYPT_CONTAINER=${disk}2
		create_crypt ${CRYPT_CONTAINER} $KEY
		open_crypt ${CRYPT_CONTAINER} $KEY $CRYPT_NAME
		container_dev=/dev/mapper/${CRYPT_NAME}

	else
		container_dev=${disk}2
	fi	

	create_logical_volumes $container_dev $LVGROUP $LVSWAP $LVROOT
	root_container=/dev/${LVGROUP}/${LVROOT}
	swap_container=/dev/${LVGROUP}/${LVSWAP}

elif [ "x${restore_type}" == "xEF" ]; then
	
	#select_filesystem "Select Root" "Select the root volume:"
	select_volume "Select Root" "Select the root volume:"
	root_container=$result
	
	#select_filesystem "Select Swap" "Select the swap volume:"
	select_volume "Select Swap" "Select the swap volume:"
	swap_container=$result	
	
	ask_yes_no "Continue?" "The following partitions/volumes will be overwritten\n\n$root_container\n$swap_container\n"
	if ! [ "x${result}" == "x0" ]; then
		abort
	fi	
else
	abort
fi

# Format swap space
mkswap ${swap_container}

# clone build image onto root
gunzip -c ${IMAGES_MNT}/${IMAGE_FOLDER}/${IMAGE_FILE} | partclone.ext4 -r -o ${root_container}
resize2fs ${root_container}
fsck -y ${root_container}

# Mount root
mkdir -p ${ROOT_TARGET}
mount ${root_container} ${ROOT_TARGET}

# Update fstab
update_fstab ${ROOT_TARGET} ${swap_container}

# If luks update crypttab
if [ "x${restore_type}" == "xWDL" ]; then
	update_crypttab ${ROOT_TARGET} ${CRYPT_CONTAINER} ${CRYPT_NAME}
fi

# Update boot system
update_boot ${ROOT_TARGET} ${root_container}

# If WDL or WDS show new encryption password
if [ ! -z $KEY ]; then
	show_message "Encryption Key" "\n${KEY}\n"
fi

# Setup module install after reboot
setup_module_run ${ROOT_TARGET} ${BUILD}
#shutdown -r now
exit
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

