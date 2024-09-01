#!/usr/bin/env bash

# Make sure we're synced to GitHub repo...
sudo zypper -n install git
if [ ! -d $HOME/Documents/Software/Git/WhiteSur-gtk-theme ]; then
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/Documents/Software/Git/WhiteSur-gtk-theme
else
    git -C $HOME/Documents/Software/Git/WhiteSur-gtk-theme pull origin master
fi

# Install and configure
mkdir $HOME/.themes
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/install.sh
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/install.sh -l -c Light
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/tweaks.sh -F -c Light
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/install.sh
sudo flatpak override --filesystem=xdg-config/gtk-4.0
sudo $HOME/Documents/Software/Git/WhiteSur-gtk-theme/tweaks.sh -g -b $HOME/Pictures/Toscana.jpg
