#!/bin/bash

BUILD_TOOLS=/root/build
TARGET=/tmp/pentest-build
INSTALLER=${BUILD_TOOLS}/kali2-build
TRD=${BUILD_TOOLS}/3rdparty

TMP_INSTALLER=/tmp/installer
TMP_3RD=/tmp/3rdparty

MNAME=target

mkdir -p ${TARGET}
mkdir -p ${TARGET}/${TMP_INSTALLER}
mkdir -p ${TARGET}/${TMP_3RD}

xhost +local:

systemctl stop vmware
systemctl stop vmware-workstation-server
systemctl stop posetgresql

systemd-run systemd-nspawn -D ${TARGET} -M ${MNAME} --bind=/tmp/.X11-unix:/tmp/.X11-unix --bind-ro=${INSTALLER}:${TMP_INSTALLER} --bind-ro=${TRD}:${TMP_3RD} -b

sleep 5
systemd-run -M ${MNAME} --setenv=DISPLAY=:0 xterm

