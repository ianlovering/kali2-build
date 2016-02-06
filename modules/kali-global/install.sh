#!/bin/bash

DEBIAN_PRIORITY=critical

apt-get update

apt-get -y install \
build-essential \
linux-headers-amd64 \
gcc-multilib \
ipmitool \
wakeonlan \
ipcalc \
shutter \
python-nautilus \
network-manager-vpnc \
network-manager-vpnc-gnome \
apt-file \
openvpn \
network-manager-openvpn-gnome \
rsh-redone-client \
rsh-redone-server \
krb5-user \
bridge-utils \
arptables \
ebtables \
xdotool \
xnest \
remmina \
remmina-plugin-gnome \
remmina-plugin-nx \
remmina-plugin-rdp \
remmina-plugin-telepathy \
remmina-plugin-vnc \
remmina-plugin-xdmcp \
jxplorer \
ldaptor-utils \
ldaptor-doc \
shelldap \
terminator \
zsh \
nautilus-share \
libnotify-bin \
freerdp-x11 \
wkhtmltopdf \
google-nexus-tools

systemctl stop inetd
systemctl disable inetd

cp x86_64-linux-gnu.local.conf /etc/ld.so.conf.d
ldconfig

cp vimrc /etc/vim

mkdir -p /etc/update-all/update-scripts.d
cp kali-update /etc/update-all/update-scripts.d/kali
chmod 555 /etc/update-all/update-scripts.d/kali

systemctl stop ntp
systemctl mask ntp
timedatectl set-ntp true

systemctl disable greenbone-security-assistant
systemctl disable openvas-manager
systemctl disable openvas-scanner
