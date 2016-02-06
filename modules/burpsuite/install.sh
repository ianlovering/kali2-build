#!/bin/bash

INSTALL=${1}/burpsuite

BURP_DIR=/opt/burpsuite-pro
BURP_JAR=burpsuite_pro_v1.6.25.jar
JYTHON=jython-standalone-2.7.0.jar
JRUBY=jruby-complete-9.0.0.0.jar
KIT=BurpKit-v1.01-pre.jar
JAVA_PREFS=/root/.java/.userPrefs

MENU_DIR=/usr/local/share/applications

mkdir ${BURP_DIR}
cp ${INSTALL}/${BURP_JAR} ${BURP_DIR}
cp ${INSTALL}/${JYTHON} ${BURP_DIR}
cp ${INSTALL}/${JRUBY} ${BURP_DIR}
cp ${INSTALL}/${KIT} ${BURP_DIR}

cp burpsuite-pro /usr/local/bin
chmod 555 /usr/local/bin/burpsuite-pro

mkdir -p ${MENU_DIR}
cp kali-burpsuite-pro.desktop ${MENU_DIR}
