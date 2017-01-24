#!/bin/bash -x

HOME=/root

#set hostname
echo 'astral-stalker' > /etc/hostname
sed -i 's/kali/astral-stalker/' /etc/hosts

THIRD=${1}/personal

# Install my git-repos
TOOLS_DIR=/root/Tools
DOCS_DIR=/root/Documents

pushd /root

export GIT_SSL_CAINFO=${THIRD}/ghost.bathouse.co.uk.pem
export GIT_ASKPASS=${THIRD}/gitpass

git clone https://ian@ghost.bathouse.co.uk/kali-settings-root.git .mysettings

# link settings files
ROOT_SETTINGS=/root/.mysettings

ln -s ${ROOT_SETTINGS}/tmux.conf .tmux.conf

mkdir -p .config/terminator
mkdir .msf4
mkdir -p .java/.userPrefs

rm -f .config/terminator/config; ln -s ${ROOT_SETTINGS}/terminator-config .config/terminator/config
rm -f .msf4/config; ln -s ${ROOT_SETTINGS}/msf-config .msf4/config
rm -f .gitconfig; ln -s ${ROOT_SETTINGS}/gitconfig .gitconfig
rm -rf .java/.userPrefs/burp; ln -s ${ROOT_SETTINGS}/burp .java/.userPrefs/burp
rm -f /opt/nessus/var/nessus/master.key /opt/nessus/var/nessus/global.db /opt/nessus/etc/nessus/nessus-fetch.db
ln -s ${ROOT_SETTINGS}/nessus/master.key /opt/nessus/var/nessus/master.key
ln -s ${ROOT_SETTINGS}/nessus/nessus-fetch.db /opt/nessus/etc/nessus/nessus-fetch.db

git clone https://ian@ghost.bathouse.co.uk/Documents.git
git clone https://ian@ghost.bathouse.co.uk/Tools.git Tools/Tools

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
gsettings set org.gnome.shell favorite-apps "['terminator.desktop', 'org.gnome.gedit.desktop', 'firefox-esr.desktop', 'google-chrome.desktop', 'kali-burpsuite-pro.desktop', 'kali-wireshark.desktop', 'org.gnome.Nautilus.desktop', 'shutter.desktop', 'vmware-workstation.desktop', 'quiet.desktop']"

UPDATE_DIR=/etc/update-all/update-scripts-apt.d
mkdir ${UPDATE_DIR}
cp personal-update ${UPDATE_DIR}
chmod 555 ${UPDATE_DIR}/personal-update


