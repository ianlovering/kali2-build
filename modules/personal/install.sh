#!/bin/bash

#set hostname
echo 'astral-stalker' > /etc/hostname
sed -i 's/kali/astral-stalker/' /etc/hosts

# Set up zsh theme
THEMES_FOLDER=/opt/oh-my-zsh/custom/themes

mkdir -p ${THEMES_FOLDER}
cp ian.zsh-theme ${THEMES_FOLDER}

sed -i 's/ZSH_THEME="clean"/ZSH_THEME="ian"/' ${HOME}/.zshrc

cp tmux.conf ${HOME}/.tmux.conf
echo "tmux has-session -t main || tmux new-session -d -s main" >> ${HOME}/.profile

mkdir -p ${HOME}/.config/terminator
cp terminator-config ${HOME}/.config/terminator/config

# Metasploit config
mkdir -p /root/.msf5
cp msf-config /root/.msf5/config

# Git Config
cp gitconfig /root/.gitconfig

# Become Settings
cp /root/.zshrc /home/become

# Logging Settings
cat logging.zshrc >> ${HOME}/.zshrc
mkdir -p /root/mission/logs/console

# Tool output
OUTPUT=/root/mission/output
 
if [ ! -d ${OUTPUT} ]; then
     mkdir -p ${OUTPUT}
fi
 
DEFAULT_VEIL_OUTPUT=/root/veil-output
NEW_VEIL_OUTPUT=${OUTPUT}/veil
 
sed -i 's,'${DEFAULT_VEIL_OUTPUT}','${NEW_VEIL_OUTPUT}',' /etc/veil/settings.py
mv ${DEFAULT_VEIL_OUTPUT} ${NEW_VEIL_OUTPUT}


# gedit settings
gsettings set org.gnome.gedit.preferences.editor display-right-margin true
gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
gsettings set org.gnome.gedit.preferences.editor bracket-matching true
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true

gsettings set org.gnome.gedit.preferences.editor insert-spaces true
gsettings set org.gnome.gedit.preferences.editor tabs-size 4

gsettings set org.gnome.gedit.preferences.editor use-default-font false
gsettings set org.gnome.gedit.preferences.editor editor-font 'Monospace 10'
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'

# Set favourites
gsettings set org.gnome.shell favorite-apps "['terminator.desktop', 'org.gnome.gedit.desktop', 'iceweasel.desktop', 'google-chrome.desktop', 'kali-burpsuite-pro.desktop', 'kali-wireshark.desktop', 'org.gnome.Nautilus.desktop', 'shutter.desktop', 'vmware-workstation.desktop', 'quiet.desktop']"

