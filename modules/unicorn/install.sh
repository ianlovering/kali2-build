#!/bin/bash

pushd /opt
git clone https://github.com/trustedsec/unicorn.git
popd

mkdir -p /etc/update-all/update-scripts.d
cp unicorn-update /etc/update-all/update-scripts.d/unicorn
chmod 555 /etc/update-all/update-scripts.d/unicorn
