#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/apktool/

APK_DIR=/opt/apktool
APK_JAR=apktool_2.0.2.jar
APK_SCRIPT=apktool

mkdir ${APK_DIR}
mv ${APK_JAR} ${APK_DIR}
mv ${APK_SCRIPT} ${APK_DIR}

pushd ${APK_DIR}
chmod 555 ${APK_SCRIPT}
ln -s ${APK_JAR} apktool.jar
popd

pushd /usr/local/bin
ln -s ${APK_DIR}/apktool apktool
popd

