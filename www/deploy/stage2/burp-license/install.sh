#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/burp-license/

JAVA_PREFS=/root/.java/.userPrefs

tar xf burp.tar.gz
mkdir -p ${JAVA_PREFS}
cp -r burp ${JAVA_PREFS}

