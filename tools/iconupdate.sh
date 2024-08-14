#!/usr/bin/env bash

git -C $HOME/Documents/Software/Git/WhiteSur-icon-theme pull origin master
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean
rsync -a --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
tar -czf $HOME/.icons/WhiteSurCustom.tar.xz WhiteSur
