#!/bin/bash

cp metasploit-post-update /usr/local/sbin
chmod 555 /usr/local/sbin/metasploit-post-update

cp 99metasploit-oci8 /etc/apt/apt.conf.d
chmod 555 /etc/apt/apt.conf.d/99metasploit-oci8

# Initialise metasploit
systemctl enable postgresql
systemctl start postgresql
msfdb init
systemctl stop postgresql

gem install ruby-oci8
/usr/local/sbin/metasploit-post-update
