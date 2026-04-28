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
if [ ! -d $HOME/Documents/Software/Git/dhruva ]; then
    git clone https://github.com/NarkAgni/dhruva $HOME/Documents/Software/Git/dhruva
else
    git -C $HOME/Documents/Software/Git/dhruva pull origin main
fi
if [ ! -d $HOME/Documents/Software/Git/rounded-windows ]; then
    git clone https://github.com/Nathanaelrc/rounded-windows $HOME/Documents/Software/Git/rounded-windows
else
    git -C $HOME/Documents/Software/Git/rounded-windows pull origin master
fi
if [ ! -d $HOME/Documents/Software/Git/gnome-shell-extensions ]; then
    git clone https://gitlab.gnome.org/GNOME/gnome-shell-extensions $HOME/Documents/Software/Git/gnome-shell-extensions
else
    git -C $HOME/Documents/Software/Git/gnome-shell-extensions pull origin main
fi
