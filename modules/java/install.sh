#!/bin/bash

function installjava {

	local_java_name=${1}
	local_java_jinfo=.${local_java_name}.jinfo

	local_openjdk_name=java-1.7.0-openjdk-amd64
	local_openjdk_name2=java-7-openjdk-amd64
	local_openjdk_jinfo=.${local_openjdk_name}.jinfo
	
	pushd /usr/lib/jvm	
	
	cp ${local_openjdk_jinfo} ${local_java_jinfo}
	sed -i "s/${local_openjdk_name}/${local_java_name}/g" ${local_java_jinfo}                                         
	sed -i "s/${local_openjdk_name2}/${local_java_name}/g" ${local_java_jinfo} 
	sed -i "s/IcedTeaPlugin.so/libnpjp2.so/g" ${local_java_jinfo} 
	cat  ${local_java_jinfo} | grep -E '^(hl|jre|jdk)' | awk '{print "/usr/bin/" $2 " " $2 " " $3 " 30 \n"}' | xargs -t -n4 update-alternatives --verbose --install
	update-alternatives --verbose --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /usr/lib/jvm/${local_java_name}/jre/lib/amd64/libnpjp2.so 30
	update-alternatives --verbose --install /usr/lib/xulrunner-addons/plugins/libjavaplugin.so xulrunner-1.9-javaplugin.so /usr/lib/jvm/${local_java_name}/jre/lib/amd64/libnpjp2.so 30
	
	popd
}

INSTALL=${1}/java
cd /tmp

# Java 6 Install
JAVA_VERSION=jdk1.6.0_45
JAVA_NAME=${JAVA_VERSION}-amd64

sh ${INSTALL}/jdk-6u45-linux-x64.bin
mv  ${JAVA_VERSION} /usr/lib/jvm/${JAVA_NAME}
installjava ${JAVA_NAME}

# Java 8 Install
JAVA_VERSION=jdk1.8.0_60
JAVA_NAME=${JAVA_VERSION}-amd64

tar xf ${INSTALL}/jdk-8u60-linux-x64.tar.gz
mv  ${JAVA_VERSION} /usr/lib/jvm/${JAVA_NAME}
installjava ${JAVA_NAME}
ln -fs /usr/lib/jvm/${JAVA_NAME} /usr/lib/jvm/java8

update-java-alternatives -s ${JAVA_NAME}
