#!/bin/bash

INSTALL=${1}/apktool

APK_DIR=/opt/apktool
APK_JAR=apktool_2.0.2.jar
APK_SCRIPT=apktool

mkdir ${APK_DIR}
cp ${INSTALL}/${APK_JAR} ${APK_DIR}
cp ${INSTALL}/${APK_SCRIPT} ${APK_DIR}

pushd ${APK_DIR}
chmod 555 ${APK_SCRIPT}
ln -s ${APK_JAR} apktool.jar
popd

pushd /usr/local/bin
ln -s ${APK_DIR}/${APK_SCRIPT} apktool
popd

