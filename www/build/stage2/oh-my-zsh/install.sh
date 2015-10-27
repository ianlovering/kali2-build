#!/bin/bash

export ZSH=/opt/oh-my-zsh
ZSH_INSTALL=./zsh_install.sh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O ${ZSH_INSTALL}
sed -i '/env zsh/d' ${ZSH_INSTALL}
chmod 755 ${ZSH_INSTALL}
sh -c ${ZSH_INSTALL}
sed -i 's/# DISABLE_AUTO_UPDATE/DISABLE_AUTO_UPDATE/' ${HOME}/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="clean"/' ${HOME}/.zshrc
chsh -s /bin/zsh
