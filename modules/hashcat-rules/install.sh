#!/bin/bash

# Add backports to sources
srcs=/etc/apt/sources.list
echo "# Jessie backports" >> $srcs
echo "deb http://ftp.uk.debian.org/debian jessie-backports main contrib non-free" >> $srcs

apt-get update
apt-get install -t jessie-backports nvidia-driver

