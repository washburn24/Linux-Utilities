#!/usr/bin/env bash

# Grab updated icon set from Github, integrate to custom folder, rebuild tarball
git -C $HOME/Documents/Software/Git/WhiteSur-icon-theme pull origin master
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean
rsync -a --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
cd $HOME/.icons
tar -czf $HOME/.icons/WhiteSurCustom.tar.xz WhiteSur
mv -f $HOME/.icons/WhiteSurCustom.tar.xz $HOME/Documents/Linux-Utilities/config/Icons

# Copy Vim and Bash configuration files to backup and synced location if they're newer
rsync -a $HOME/.vimrc $HOME/Documents/Linux-Utilities/config/Dotfiles/
rsync -a $HOME/.bashrc $HOME/Documents/Linux-Utilities/config/Dotfiles/
#rsync -a $HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/sylesheet.css $HOME/Documents/Linux-Utilities/config/DashtoDock/
