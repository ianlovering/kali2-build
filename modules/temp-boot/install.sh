#!/bin/bash

echo "luks-b3b69288-a7b9-49e8-8627-de66846a4fb0 UUID=b3b69288-a7b9-49e8-8627-de66846a4fb0   none    luks" >> /etc/crypttab

echo "UUID=d8842a70-086a-4469-9699-10cc9e6778d3 /   ext4    errors=remount-ro   0   0" >> /etc/fstab

echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub

update-initramfs -u


