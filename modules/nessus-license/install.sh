#!/bin/bash

# Nessus License
pushd ${1}/nessus-license
cp -f nessus-fetch.rc /opt/nessus/etc/nessus
cp -f nessus-fetch.db /opt/nessus/etc/nessus
cp -f master.key /opt/nessus/var/nessus
popd

pushd /opt/nessus/sbin
./nessuscli update --all
popd

