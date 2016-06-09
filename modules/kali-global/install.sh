#!/bin/bash

cp x86_64-linux-gnu.local.conf /etc/ld.so.conf.d
ldconfig

cp vimrc /etc/vim

mkdir -p /etc/update-all/update-scripts.d
cp kali-update /etc/update-all/update-scripts.d/kali
chmod 555 /etc/update-all/update-scripts.d/kali

timedatectl set-ntp true

