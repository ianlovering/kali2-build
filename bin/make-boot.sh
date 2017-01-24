#!/bin/bash

DISK=${1}
ROOT=${2}
SWAP=${3}
EFI=${4}

mkswap ${SWAP}
mkfs.vfat -F32 ${EFI}

local root_uuid=$(blkid -s UUID ${ROOT} | awk -F\" '{ print $2 }')
local efi_uuid=$(blkid -s UUID ${EFI} | awk -F\" '{ print $2 }')
local swap_uuid=$(blkid -s UUID ${SWAP} | awk -F\" '{ print $2 }')

cp /tmp/installer/etc/fstab /etc/fstab

sed -i "s/ROOT_ID/${root_uuid}/" /etc/fstab
sed -i "s/EFI_ID/${efi_uuid}/" /etc/fstab
sed -i "s/SWAP_ID/${swap_uuid}/" /etc/fstab

mount /boot/efi

update-grub
update-initramfs -u
grub-install --force-extra-removable ${DISK}
shutdown now

