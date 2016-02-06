#!/bin/bash

ODBC=msodbcsql-11.0.2270.0
JDBC_TAR=sqljdbc_4.2.6225.100_enu.tar.gz
JDBC_DIR=sqljdbc_4.2

WDIR=/tmp/ms-sql
INSTALL=${1}/ms-sql


mkdir -p ${WDIR}
pushd ${WDIR}

tar xf ${INSTALL}/${ODBC}.tar.gz
pushd ${ODBC}
sed -i 's/local proc=$(uname -p)/local proc=$req_proc/g' build_dm.sh
sed -i 's/"unixODBC".$RANDOM.$RANDOM.$RANDOM/"unixODBC"/g' build_dm.sh
bash build_dm.sh --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu --accept-warning 

pushd /tmp/unixODBC/unixODBC-2.3.0
make install
popd

ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/libssl.so.10
ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/libcrypto.so.10

sed -i 's/local proc=$(uname -p)/local proc=$req_proc/g' install.sh
sed -i '/Checking that required libraries are installed/,/return 0/{//!d}' install.sh
bash install.sh install --bin-dir=/usr/local/bin --accept-license
popd

pushd /opt/microsoft
tar xf ${INSTALL}/${JDBC_TAR}
popd

popd

