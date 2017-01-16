#!/bin/bash

INSTALL=${1}/nipper

dpkg --force-all -i ${INSTALL}/nipperstudio-*.deb
apt-get -yq -f install

