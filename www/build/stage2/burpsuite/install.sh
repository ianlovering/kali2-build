#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/burpsuite/

BURP_DIR=/opt/burpsuite-pro
BURP_JAR=burpsuite_pro_v1.6.25.jar
JYTHON=jython-standalone-2.7.0.jar
JRUBY=jruby-complete-9.0.0.0.jar
KIT=BurpKit-v1.01-pre.jar
JAVA_PREFS=/root/.java/.userPrefs

MENU_DIR=/usr/local/share/applications

mkdir ${BURP_DIR}
mv ${BURP_JAR} ${BURP_DIR}
mv ${JYTHON} ${BURP_DIR}
mv ${JRUBY} ${BURP_DIR}
mv ${KIT} ${BURP_DIR}

mv burpsuite-pro /usr/local/bin
chmod 555 /usr/local/bin/burpsuite-pro

#tar xf burp.tar.gz
#mkdir -p ${JAVA_PREFS}
#cp -r burp ${JAVA_PREFS}

mkdir -p ${MENU_DIR}
cp kali-burpsuite-pro.desktop ${MENU_DIR}
