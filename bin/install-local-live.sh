#!/bin/bash

TMP=/tmp/install
TMP_PACKS=${TMP}/packages.txt

INSTALL=/tmp/installer
MODS=${INSTALL}/modules
MOD_LIST=${INSTALL}/etc/modules-live.txt

THIRD_PARTY=/tmp/3rdparty

HOME=/root

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "debian-live" > /etc/hostname
echo "luks-b3b69288-a7b9-49e8-8627-de66846a4fb0\tUUID=b3b69288-a7b9-49e8-8627-de66846a4fb0" >> /etc/crypttab

mkdir -p ${TMP}

for module in $(cat ${MOD_LIST}); do
    MOD_PACKS=${MODS}/${module}/packages.txt    
    if [ -s "${MOD_PACKS}" ]; then  
        cat "${MOD_PACKS}" >> ${TMP_PACKS}
    fi	
done

export DEBIAN_FRONTEND=noninteractive
export DISPLAY=:0

apt-get -yq install $( < ${TMP_PACKS})

rm -rf ${TMP}

echo "nameserver 8.8.8.8" > /etc/resolv.conf

for module in $(cat ${MOD_LIST}); do
    echo $module
    if [ -s "${MODS}/${module}/install.sh" ]; then
        echo run  
	    pushd ${MODS}/${module}
	    ./install.sh ${THIRD_PARTY}
	    popd
    fi
done

update-initramfs -u

