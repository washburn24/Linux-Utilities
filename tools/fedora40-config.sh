#!/usr/bin/env bash

# Clone some GitHub repos...
git clone https://github.com/vinceliuice/WhiteSur-icon-theme $HOME/Documents/Software/Git/WhiteSur-icon-theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/Documents/Software/Git/WhiteSur-gtk-theme
git clone https://github.com/washburn24/Linux-Utilities $HOME/Documents/Linux-Utilities

# Install some gtk and icon themes:
mkdir $HOME/.icons $HOME/.themes
sudo dnf -y install gnome-tweaks adw-gtk3-theme yaru-theme
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean

# Make some custom changes that are only relevant to me:
cp $HOME/Documents/Linux-Utilities/config/icons/WhiteSurCustom.tar.xz $HOME/.icons
tar -C $HOME/.icons -xvf $HOME/.icons/WhiteSurCustom.tar.xz
rsync -a -v --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
tar -czf $HOME/.icons/WhiteSurCustom.tar.xz WhiteSur
rsync -a -v --ignore-existing $HOME/Documents/Linux-Utilities/config/gnome-shell/MacLight/* $HOME/.themes/MacLight/
rsync -a -v --ignore-existing $HOME/Documents/Linux-Utilities/config/gnome-shell/MacDark/* $HOME/.themes/MacDark/
sudo cp -f $HOME/Documents/Linux-Utilities/audio/snd.conf /etc/modprobe.d/  # Bug fix for speaker control on Lenovo Yoga 9

# Command line control of gnome-tweaks; this sets icons, shell, legacy app themes, and title bar formatting:
# The themes here need to be installed for these commands to work, syntax can be deciphered using 'dconf watch /' and monitoring the output when you set your preferred # gnome-tweaks settings in the GUI.
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
gsettings set org.gnome.shell.extensions.user-theme name 'MacLight'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close:appmenu'
flatpak -y update  # Possibly redundant but makes Flatpaks look for the new icon theme

# Controlling Just Perfection from the command line (move clock and notifications to the right):
gsettings set org.gnome.shell.extensions.just-perfection clock-menu-position 1
gsettings set org.gnome.shell.extensions.just-perfection clock-menu-position-offset 6
gsettings set org.gnome.shell.extensions.just-perfection notification-banner-position 2

# Install some applications:
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf -y install google-chrome-stable_current_x86_64.rpm  # Grab Google Chrome's latest and install locally
flatpak -y install flathub io.github.shiftey.Desktop  # Github Desktop, syntax found via Flathub's web install
flatpak -y install flathub zoom geary inkscape diffuse retext # Multi install for Flatpak apps, specifying Flathub as the repo
flatpak -y install fedora mines sudoku chess aisleriot  # Multi install for Flatpak apps, specifying Fedora as the repo

