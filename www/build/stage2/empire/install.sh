#!/bin/bash

pushd /opt
git clone https://github.com/PowerShellEmpire/Empire.git
pushd Empire/setup
yes | ./install.sh

popd
popd

for launcher in empire; do
	mv ${launcher} /usr/local/bin
	chmod 555 /usr/local/bin/${launcher}
done

mkdir -p /etc/update-all/update-scripts.d
mv empire-update /etc/update-all/update-scripts.d/empire
chmod 555 /etc/update-all/update-scripts.d/empire
