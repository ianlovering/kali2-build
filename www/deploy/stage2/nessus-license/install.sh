#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/nessus-license/

# Nessus License
mv -f nessus-fetch.rc /opt/nessus/etc/nessus
mv -f nessus-fetch.db /opt/nessus/etc/nessus
mv -f master.key /opt/nessus/var/nessus

sleep 1
pushd /opt/nessus/sbin
./nessuscli update --all
popd

