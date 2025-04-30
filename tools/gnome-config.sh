#!/usr/bin/env bash

# Function to check for command availability senses package tool to determine distro
has_command() {
    command -v "$1" &> /dev/null
}

# Install some native applications by distro...
if has_command apt; then
    echo "apt package manager found, installing apps for Debian/Ubuntu..."
    sudo apt -y install git gnome-tweaks flatpak gnome-software gnome-software-plugin-flatpak
    sudo apt -y install neofetch gnome-contacts gnome-calendar geary flameshot   # Debian native repo
elif has_command dnf; then
    echo "dnf package manager found, installing apps for Fedora..."
    sudo dnf -y install git gnome-tweaks geary flameshot                         # Fedora native repo
elif has_command zypper; then
    echo "zypper package manager found, installing apps for openSUSE..."
    sudo zypper -n install git neofetch geary flameshot inkscape gnome-tweaks    # openSUSE native repo
elif has_command pacman; then
    echo "pacman package manager found, installing apps for Manjaro..."
    sudo pacman -Syu --noconfirm geary flameshot                                 # Manjaro native repo
else
    echo "Warning: Linux distribution not detected for installation. Exiting to avoid harm."; exit 1
fi

# Install some flatpak applications...
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak -y install flathub io.github.shiftey.Desktop org.gnome.gitlab.somas.Apostrophe
sudo flatpak -y install flathub zoom diffuse spotify org.vim.Vim com.discordapp.Discord

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

# Make some custom changes that are only relevant to me...
#if [ ! -d /usr/share/gnome-shell/theme/Yaru-blue ]; then
#    sudo mkdir /usr/share/gnome-shell/theme
#    sudo mkdir /usr/share/gnome-shell/theme/Yaru-blue
#    sudo cp $HOME/Documents/Linux-Utilities/config/Themes/Yaru-blue-Ubuntu2404.css /usr/share/gnome-shell/theme/Yaru-blue/gnome-shell.css
#fi
sudo cp -f $HOME/Documents/Linux-Utilities/audio/alsa-base.conf /etc/modprobe.d/  # Bug fix for audio on Lenovo Yoga 9
tar -C $HOME/.icons -xf $HOME/Documents/Linux-Utilities/config/Icons/WhiteSurCustom.tar.xz
rsync -a --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/  # Sync only new icons to not overwrite custom changes
#rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacLight/* $HOME/.themes/MacLight/
#rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacDark/* $HOME/.themes/MacDark/
if [ ! -f $HOME/.vimrc ]; then  # Copy new dotfiles if they don't exist or if they exist and are newer update the archive
    cp $HOME/Documents/Linux-Utilities/config/Dotfiles/.vimrc $HOME
else
    rsync -a $HOME/.vimrc $HOME/Documents/Linux-Utilities/config/Dotfiles/
fi
if [ ! -f $HOME/.bashrc ]; then
    cp $HOME/Documents/Linux-Utilities/config/Dotfiles/.bashrc $HOME
else
    rsync -a $HOME/.bashrc $HOME/Documents/Linux-Utilities/config/Dotfiles/
fi

# Gnome general settings adjustments...
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll 'false'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'

# Command line control of gnome-tweaks; this sets icons, shell, legacy app themes, and title bar formatting...
# Syntax for gsettings can be deciphered using 'dconf watch /' while monitoring settings adjustments in GUI tools
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
dconf write /org/gnome/shell/extensions/user-theme/name 'WhiteSur-Light'
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Light'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'

# Controlling Just Perfection from the command line (move clock and notifications to the right)...
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position 1
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position-offset 7
dconf write /org/gnome/shell/extensions/just-perfection/notification-banner-position 2

# Configure flameshot screen capture software and set PrintScreen shortcut to .sh to work around permissions bug...
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name Flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command ~/Documents/Linux-Utilities/tools/flameshot-workaround.sh
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding Print

# Install Google Chrome but delete any old versions hanging around...
if [ -f google-chrome-stable_current_x86_64.rpm ] || [ -f google-chrome-stable_current_amd64.deb ]; then
    rm -f google-chrome-stable_current_*
fi
if has_command zypper; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
#    sudo zypper -n install ./google-chrome-stable_current_x86_64.rpm
elif has_command dnf; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    sudo dnf -y install ./google-chrome-stable_current_x86_64.rpm
elif has_command apt; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt -y install ./google-chrome-stable_current_amd64.deb
#elif has_command pamac; then
#    sudo pamac build --no-confirm google-chrome
fi
rm -f google-chrome-stable_current_*
