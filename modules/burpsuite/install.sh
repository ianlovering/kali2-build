#!/bin/bash

INSTALL=${1}/burpsuite

BURP_DIR=/opt/burpsuite-pro
BURP_JAR=$(ls -rv ${INSTALL}/burpsuite_pro*.jar | xargs -n 1 | head -n 1)
JYTHON=$(ls -rv ${INSTALL}/jython-standalone-*.jar | xargs -n 1 | head -n 1)
JRUBY=$(ls -rv ${INSTALL}/jruby-complete*.jar | xargs -n 1 | head -n 1)
KIT=$(ls -rv ${INSTALL}/BurpKit-*.jar | xargs -n 1 | head -n 1)

MENU_DIR=/usr/local/share/applications

mkdir ${BURP_DIR}
cp ${BURP_JAR} ${BURP_DIR}
cp ${JYTHON} ${BURP_DIR}
cp ${JRUBY} ${BURP_DIR}
cp ${KIT} ${BURP_DIR}

cp burpsuite-pro /usr/local/bin
chmod 555 /usr/local/bin/burpsuite-pro

mkdir -p ${MENU_DIR}
cp kali-burpsuite-pro.desktop ${MENU_DIR}
