#!/usr/bin/env bash

# Clone some GitHub repos...
sudo apt -y install git
git clone https://github.com/vinceliuice/WhiteSur-icon-theme $HOME/Documents/Software/Git/WhiteSur-icon-theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/Documents/Software/Git/WhiteSur-gtk-theme
git clone https://github.com/washburn24/Linux-Utilities $HOME/Documents/Linux-Utilities

# Install some gtk and icon themes:
mkdir $HOME/.icons $HOME/.themes
sudo apt -y install gnome-tweaks
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean

# Make some custom changes that are only relevant to me:
cp $HOME/Documents/Linux-Utilities/config/Icons/WhiteSurCustom.tar.xz $HOME/.icons
tar -C $HOME/.icons -xf $HOME/.icons/WhiteSurCustom.tar.xz
rsync -a --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacLight/* $HOME/.themes/MacLight/
rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacDark/* $HOME/.themes/MacDark/
sudo cp -f $HOME/Documents/Linux-Utilities/audio/snd.conf /etc/modprobe.d/  # Bug fix for speaker control on Lenovo Yoga 9

# Command line control of gnome-tweaks; this sets icons, shell, legacy app themes, and title bar formatting:
# The themes here need to be installed for these commands to work
# Syntax for gsettings can be deciphered using 'dconf watch /' while monitoring settings adjustments in GUI tools
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
gsettings set org.gnome.shell.extensions.user-theme name 'MacLight'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close:appmenu'
flatpak -y update  # Possibly redundant but makes Flatpaks look for the new icon theme

# Controlling Just Perfection from the command line (move clock and notifications to the right):
gsettings set org.gnome.shell.extensions.just-perfection clock-menu-position 1
gsettings set org.gnome.shell.extensions.just-perfection clock-menu-position-offset 6
gsettings set org.gnome.shell.extensions.just-perfection notification-banner-position 2

# Gnome general settings adjustments
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll 'false'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'
gsettings set org.gnome.control-center window-state 'uint32 0'

# Install some applications:
if [ ! -f google-chrome-stable_current_amd64.deb ]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
fi  # Checking for file existence helps with script debug but isn't very useful in real use cases
sudo apt -y install ./google-chrome-stable_current_amd64.deb  # Grab Google Chrome's latest and install locally
sudo apt -y install neofetch gnome-contacts gnome-calendar
rm -f google-chrome-stable_current_amd64.deb
#sudo dnf -y install tlp tlp-rdw  # Battery life optimization tools
flatpak -y install flathub io.github.shiftey.Desktop  # Github Desktop, syntax found via Flathub's web install
flatpak -y install flathub zoom geary inkscape diffuse retext org.vim.Vim  # Flathub as repo, multi install
#flatpak -y install fedora org.gnome.Mines org.gnome.Sudoku org.gnome.Chess org.gnome.Aisleriot  # Fedora as repo, multi install

# Install flameshot screen capture software and set PrintScreen shortcut to .sh to work around permissions bug
sudo apt -y install flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name Flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command ~/Documents/Linux-Utilities/tools/flameshot-workaround.sh
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding Print
