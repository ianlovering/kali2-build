#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/nessus/

dpkg -i Nessus-6.4.3-debian6_amd64.deb

NCLI=/opt/nessus/sbin/nessuscli
${NCLI} fix --set listen_address=127.0.0.1
${NCLI} fix --set auto_update=no

# Configure Nessus
${NCLI} mkcert -q
chmod 755 expect-nessus-client-cert
./expect-nessus-client-cert
${NCLI} fix --set force_pubkey_auth=yes

CERT_DIR=/opt/nessus/var/certs/pentest
mkdir -p ${CERT_DIR}

pushd /opt/nessus/var/nessus/tmp/
mv cert_pentest.pem ${CERT_DIR}
mv key_pentest.pem ${CERT_DIR}
popd

pushd ${CERT_DIR}
openssl pkcs12 -export -out combined_pentest.pfx -inkey key_pentest.pem -in cert_pentest.pem -chain -CAfile /opt/nessus/com/nessus/CA/cacert.pem -passout 'pass:password' -name 'Nessus User Certificate for: pentest'
popd

mkdir -p /etc/update-all/update-scripts.d
mv nessus-update /etc/update-all/update-scripts.d/nessus
chmod 555 /etc/update-all/update-scripts.d/nessus

systemctl disable nessusd
