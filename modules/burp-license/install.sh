#!/bin/bash

JAVA_PREFS=/root/.java/.userPrefs

mkdir -p ${JAVA_PREFS}
pushd ${JAVA_PREFS}
tar xf ${1}/burp-license/burp.tar.gz
popd

