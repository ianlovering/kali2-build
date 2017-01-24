#!/bin/bash

cp x86_64-linux-gnu.local.conf /etc/ld.so.conf.d
ldconfig

cp vimrc /etc/vim

timedatectl set-ntp true

