#!/bin/bash

dpkg --add-architecture i386 && apt-get -y update &&
apt-get -y install wine32
