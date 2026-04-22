#!/usr/bin/bash

# Function to check for command availability senses package tool to determine distro
has_command() {
    command -v "$1" &> /dev/null
}

# Change sudo timeout so the whole script runs on reasonable internet connections
if  has_command pacman || has_command apt || has_command dnf || has_command zypper; then
    echo "Defaults timestamp_timeout=60" | sudo tee /etc/sudoers.d/timeout_settings
    sudo chmod 0440 /etc/sudoers.d/timeout_settings
fi

## Install some native applications by distro...
if has_command pacman; then
    echo "Package manager found 'pacman'. Installing apps for Arch/CachyOS..."
    sudo pacman -Syu --noconfirm
    sudo pacman -Syu --noconfirm geary flameshot octopi diffuse gvim paru git     # Arch native repo
    sudo pacman -Syu --noconfirm gnome-calendar gnome-contacts gnome-weather gnome-maps
    sudo pacman -Syu --noconfirm apostrophe inkscape adw-gtk-theme python-pip octopi
    sudo pacman -Syu --noconfirm github-desktop extension-manager gnome-terminal
    paru -Syu --noconfirm nautilus-open-in-ptyxis joplin-desktop google-chrome pycharm
    if has_command meld; then
        sudo pacman -Ru --noconfirm alacritty meld
    fi
    if ! has_command spotify-launcher; then    # Spotify breaks icon theme, so don't re-install
        sudo pacman -Syu --noconfirm spotify-launcher
    fi
elif has_command apt; then
    echo "Package manager found 'apt. Installing apps for Debian/Ubuntu..."
    sudo apt -y install fastfetch gnome-contacts gnome-calendar geary flameshot   # Debian native repo
    sudo apt -y install git rsync gnome-tweaks flatpak gnome-software gnome-software-plugin-flatpak
elif has_command dnf; then
    echo "Package manager found 'dnf'. Installing apps for Fedora..."
    sudo dnf -y install git gnome-tweaks geary flameshot gnome-software           # Fedora native repo
elif has_command zypper; then
    echo "Package manager found 'zypper'. Installing apps for openSUSE..."
    sudo zypper -n install git fastfetch geary flameshot inkscape gnome-tweaks    # openSUSE native repo
else
    echo "Error! Linux distribution not detected for installation. Exiting to avoid harm."; exit 1
fi

# Install some flatpak applications if not on Arch/Cachy...
if ! has_command pacman; then
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak -y install flathub spotify io.github.shiftey.Desktop com.mattjakeman.ExtensionManager
    sudo flatpak override --filesystem=xdg-config/gtk-3.0
    sudo flatpak override --filesystem=xdg-config/gtk-4.0
else
    echo "No Flatpak installed for Arch/CachyOS, use 'pacman -S flatpak to override'"
fi

# Clone some GitHub repos...
chmod +x github-sync.sh
./github-sync.sh

# Install some gtk, icon, and Vim themes...
if [[ ! -d $HOME/.icons/ || ! -d $HOME/.themes/ || ! -d $HOME/.vim/colors/ ]]; then
    mkdir $HOME/.icons $HOME/.themes $HOME/.vim $HOME/.vim/colors
fi
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean
tar -C $HOME/.icons -xf $HOME/Documents/Linux-Utilities/config/Icons/WhiteSurCustom.tar.xz
rsync -a --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/  # Sync only new icons to not overwrite custom changes
cd $HOME/.icons
tar -czf $HOME/.icons/WhiteSurCustom.tar.xz WhiteSur
mv -f $HOME/.icons/WhiteSurCustom.tar.xz $HOME/Documents/Linux-Utilities/config/Icons
cp $HOME/Documents/Linux-Utilities/config/Themes/codedark.vim $HOME/.vim/colors/
cd $HOME/Documents/Software/Git/dhruva
make install
cd $HOME/Documents/Software/Git/rounded-windows
chmod +x install.sh
./install.sh
cd $HOME/Documents/Linux-Utilities/tools

# Make some custom changes that are only relevant to me...
rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacLight/* $HOME/.themes/MacLight/
rsync -a --ignore-existing $HOME/Documents/Linux-Utilities/config/Themes/MacDark/* $HOME/.themes/MacDark/
sudo cp -f $HOME/Documents/Linux-Utilities/audio/alsa-base.conf /etc/modprobe.d/  # Bug fix for audio on Lenovo Yoga 9
if [ ! -f $HOME/.vimrc ]; then  # Copy new dotfiles if they don't exist or if they exist and are newer update the archive
    cp $HOME/Documents/Linux-Utilities/config/Dotfiles/.vimrc $HOME
else
    rsync -a $HOME/.vimrc $HOME/Documents/Linux-Utilities/config/Dotfiles/
fi

# Gnome general settings adjustments...
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll 'false'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'
gsettings set org.gnome.desktop.interface enable-hot-corners 'false'
gsettings set org.gnome.shell always-show-log-out true
gsettings set org.gnome.mutter edge-tiling false

# Command line control of gnome-tweaks; this sets icons, shell, legacy app themes, and title bar formatting...
# Syntax for gsettings can be deciphered using 'dconf watch /' while monitoring settings adjustments in GUI tools
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur'"
dconf write /org/gnome/shell/extensions/user-theme/name "'MacDark'"
dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3'"
dconf write /org/ghome/mutter/center-new-windows 'false'
#gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'

# Controlling Just Perfection from the command line (move clock and notifications to the right)...
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position 1
dconf write /org/gnome/shell/extensions/just-perfection/clock-menu-position-offset 10
dconf write /org/gnome/shell/extensions/just-perfection/notification-banner-position 2
dconf write /org/gnome/shell/extensions/just-perfection/osd-position 3

# Configure flameshot screen capture software and set PrintScreen shortcut to .sh to work around permissions bug...
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name Flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command ~/Documents/Linux-Utilities/tools/flameshot-workaround.sh
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding Print
