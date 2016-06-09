#!/bin/bash

#set hostname
echo 'astral-stalker' > /etc/hostname
sed -i 's/kali/astral-stalker/' /etc/hosts

THIRD=${1}/personal

# Install my git-repos
TOOLS_DIR=/root/Tools
DOCS_DIR=/root/Documents

export GIT_SSL_NO_VERIFY=true

pushd /root
expect -f ${THIRD}/expect-git-documents
expect -f ${THIRD}/expect-git-root-settings
#expect -f ${THIRD}/expect-git-chrome-settings

pushd ${TOOLS_DIR}
expect -f ${THIRD}/expect-git-tools
pushd Tools
git config http.sslVerify "false"
popd
popd

pushd ${DOCS_DIR}
git config http.sslVerify "false"
popd

# link settings files
ROOT_SETTINGS=/root/.mysettings

# install extra packages
KALI_PACKAGES=${ROOT_SETTINGS}/kali-packages.txt
if [ -s ${KALI_PACKAGES} ]; then
    DEBIAN_PRIORITY=critical
    apt-get update
    apt-get -y install $(< ${KALI_PACKAGES})
fi

ln -s ${ROOT_SETTINGS}/tmux.conf .tmux.conf

mkdir -p .config/terminator
mkdir .msf4
mkdir .java

ln -s ${ROOT_SETTINGS}/terminator-config .config/terminator/config
ln -s ${ROOT_SETTINGS}/msf-config .msf4/config
ln -s ${ROOT_SETTINGS}/gitconfig .gitconfig
ln -s ${ROOT_SETTINGS}/burp .java/burp

popd

# Set up zsh theme
THEMES_FOLDER=/opt/oh-my-zsh/custom/themes

mkdir -p ${THEMES_FOLDER}
cp ian.zsh-theme ${THEMES_FOLDER}

sed -i 's/ZSH_THEME="clean"/ZSH_THEME="ian"/' ${HOME}/.zshrc

echo "tmux has-session -t main || tmux new-session -d -s main" >> ${HOME}/.profile

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

