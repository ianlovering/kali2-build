#!/bin/bash

TARGET=/root/build/target
INSTALLER=/root/build/kali2-build
TRD=/root/build/3rdparty

TMP_INSTALLER=/tmp/installer
TMP_3RD=/tmp/3rdparty

MNAME=target

mkdir -p ${TARGET}
mkdir -p ${TARGET}/${TMP_INSTALLER}
mkdir -p ${TARGET}/${TMP_3RD}

xhost +local:

systemd-run systemd-nspawn -D ${TARGET} -M ${MNAME} --bind=/tmp/.X11-unix:/tmp/.X11-unix --bind-ro=${INSTALLER}:${TMP_INSTALLER} --bind-ro=${TRD}:${TMP_3RD} -b

sleep 5
systemd-run -M ${MNAME} --setenv=DISPLAY=:0 xterm ${TMP_INSTALLER}/bin/update-local.sh

