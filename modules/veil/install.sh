#!/bin/bash

pushd /opt
git clone https://github.com/Veil-Framework/Veil.git
pushd Veil
sed -i 's!Veil-Evasion/setup \&\& \./setup\.sh!Veil-Evasion/setup \&\& \./setup\.sh -s!' Install.sh
yes | ./Install.sh -c

popd
popd

for launcher in veil-evasion veil-pillage veil-catapult veil-ordnance; do
	cp ${launcher} /usr/local/bin
	chmod 555 /usr/local/bin/${launcher}
done

apt-get -y install python-psycopg2

mkdir -p /etc/update-all/update-scripts.d
cp veil-update /etc/update-all/update-scripts.d/veil
chmod 555 /etc/update-all/update-scripts.d/veil
