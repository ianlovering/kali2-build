#!/bin/bash

WDIR=/tmp/sedutil

UTIL_ARCHIVE=sedutil_LINUX.tgz
PBA_UEFI=UEFI64_Release.img.gz
PBA_BIOS=LINUXPBARelease.img.gz
RESCUE=Rescue.img.gz

SHARE=/usr/local/share/sedutil

mkdir -p ${WDIR}
pushd ${WDIR}

for f in $UTIL_ARCHIVE $PBA_UEFI $PBA_BIOS $RESCUE; do
    wget https://github.com/Drive-Trust-Alliance/exec/blob/master/${f}?raw=true -O ${f}
done

mkdir -p ${SHARE}
for f in $PBA_UEFI $PBA_BIOS $RESCUE; do
    mv $f ${SHARE}
done

tar xf ${UTIL_ARCHIVE}
mv sedutil/*.txt ${SHARE}
mv sedutil/*.sh ${SHARE}
mv sedutil/Release_x86_64/GNU-Linux/sedutil-cli /usr/local/bin

popd
rm -rf ${WDIR}

