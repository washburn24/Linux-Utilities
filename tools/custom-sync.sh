#!/usr/bin/env bash

# Refresh Github repos for whole system
chmod +x github_sync.sh
./github_sync.sh

# Integrate icons to custom folder, rebuild tarball
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean
rsync -a --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
cd $HOME/.icons
tar -czf $HOME/.icons/WhiteSurCustom.tar.xz WhiteSur
mv -f $HOME/.icons/WhiteSurCustom.tar.xz $HOME/Documents/Linux-Utilities/config/Icons

# Install/re-install the stuff you want (extensions for dock and rounded corners of non
cd $HOME/Documents/Software/Git/dhruva
make install
cd $HOME/Documents/Software/Git/rounded-windows
chmod +x install.sh
./install.sh

# Reinstall Mac theme (this can be overwritten when called from gnome_config)
#$HOME/Documents/Software/Git/WhiteSur-gtk-theme/install.sh

# Copy Vim and Bash configuration files to backup and synced location if they're newer
rsync -a $HOME/.vimrc $HOME/Documents/Linux-Utilities/config/Dotfiles/
rsync -a $HOME/.bashrc $HOME/Documents/Linux-Utilities/config/Dotfiles/
