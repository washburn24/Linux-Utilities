#!/usr/bin/env bash

# Check command availability
has_command() {
    command -v "$1" &> /dev/null
}

# Install some applications...
if has_command apt; then
    echo "apt package manager found, installing apps for Debian/Ubuntu..."
elif has_command dnf; then
    echo "dnf package manager found, installing apps for Fedora..."
elif has_command zypper; then
    echo "zypper package manager found, installing apps for openSUSE"
    sudo zypper -n install git neofetch geary flameshot inkscape gnome-tweaks  # openSUSE native repo
    sudo flatpak -y install flathub zoom spotify diffuse org.vim.Vim io.github.shiftey.Desktop
else echo "Warning: Linux distribution not detected for installation."; exit 1

# Clone some GitHub repos...
if [ ! -d $HOME/Documents/Software/Git/WhiteSur-icon-theme ]; then
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme $HOME/Documents/Software/Git/WhiteSur-icon-theme
else
    git -C $HOME/Documents/Software/Git/WhiteSur-icon-theme pull origin master
fi
if [ ! -d $HOME/Documents/Software/Git/WhiteSur-gtk-theme ]; then
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/Documents/Software/Git/WhiteSur-gtk-theme
else
    git -C $HOME/Documents/Software/Git/WhiteSur-gtk-theme pull origin master
fi
if [ ! -d $HOME/Documents/Linux-Utilities ]; then
    git clone https://github.com/washburn24/Linux-Utilities $HOME/Documents/Linux-Utilities
else
    git -C $HOME/Documents/Linux-Utilities pull origin main
fi

# Install some gtk and icon themes...
mkdir $HOME/.icons $HOME/.themes
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean

# Install and configure WhiteSur theme for Mac style controls...
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/install.sh
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/install.sh -l -c Light
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/tweaks.sh -F -c Light
$HOME/Documents/Software/Git/WhiteSur-gtk-theme/install.sh
sudo flatpak override --filesystem=xdg-config/gtk-4.0
sudo $HOME/Documents/Software/Git/WhiteSur-gtk-theme/tweaks.sh -g -b $HOME/Pictures/Toscana.jpg

# Make some custom changes that are only relevant to me...
if [ ! -d /usr/share/gnome-shell/theme/Yaru-blue ]; then
    sudo mkdir /usr/share/gnome-shell/theme
    sudo mkdir /usr/share/gnome-shell/theme/Yaru-blue
    sudo cp $HOME/Documents/Linux-Utilities/config/Themes/Yaru-blue-Ubuntu2404.css /usr/share/gnome-shell/theme/Yaru-blue/gnome-shell.css
fi
sudo cp -f $HOME/Documents/Linux-Utilities/audio/alsa-base.conf /etc/modprobe.d/  # Bug fix for audio on Lenovo Yoga 9
tar -C $HOME/.icons -xf $HOME/Documents/Linux-Utilities/config/Icons/WhiteSurCustom.tar.xz
rsync -a --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacLight/* $HOME/.themes/MacLight/
rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacDark/* $HOME/.themes/MacDark/
if [ ! -f $HOME/.vimrc ]; then
    cp $HOME/Documents/Linux-Utilities/config/Dotfiles/.vimrc $HOME
fi
if [ ! -f $HOME/.bashrc ]; then
    cp $HOME/Documents/Linux-Utilities/config/Dotfiles/.bashrc $HOME
fi

# Command line control of gnome-tweaks; this sets icons, shell, legacy app themes, and title bar formatting...
# Syntax for gsettings can be deciphered using 'dconf watch /' while monitoring settings adjustments in GUI tools
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
gsettings set org.gnome.shell.extensions.user-theme name 'MacLight'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'

# Controlling Just Perfection from the command line (move clock and notifications to the right)...
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position 1
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position-offset 7
dconf write /org/gnome/shell/extensions/just-perfection/notification-banner-position 2

# Gnome general settings adjustments...
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll 'false'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'

# Configure flameshot screen capture software and set PrintScreen shortcut to .sh to work around permissions bug...
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name Flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command ~/Documents/Linux-Utilities/tools/flameshot-workaround.sh
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding Print

# Install Google Chrome:
#if [ ! -f google-chrome-stable_current_x86_64.rpm ]; then
#    wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
#fi  # Checking for file existence helps with script debug but isn't very useful in real use cases
#sudo zypper -n install ./google-chrome-stable_current_x86_64.rpm  # Grab Google Chrome's latest and install locally
#rm -f google-chrome-stable_current_x86_64.rpm