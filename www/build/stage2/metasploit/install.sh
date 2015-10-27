#!/bin/bash

chmod 555 metasploit-post-update
mv metasploit-post-update /usr/local/sbin

chmod 555 99metasploit-oci8
mv 99metasploit-oci8 /etc/apt/apt.conf.d

# Initialise metasploit
systemctl enable postgresql
systemctl start postgresql
msfdb init
systemctl stop postgresql

gem install ruby-oci8
/usr/local/sbin/metasploit-post-update
