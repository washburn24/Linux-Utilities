# Linux Utilities
 Some utilities for Linux/Gnome to automate setup of a clean install

### Overview
These tools are designed to make clean installs of Linux/Gnome enviroments automated including installing applications, cloning Github repos, installing themes and automatically controlling them via Tweaks and Themes.  There is also some custom configuration that can be easily automatically controlled.  Note that installing themes programatically requires a reload of Gnome Shell (a logout on Wayland) and makes them non-User Installed, which I don't really like.  So, at current I'm manually configuring a minimal set of commands that really should be done from the command line like so but can't be unless you're on an older WM:

```
flatpak -y install flathub com.mattjakeman.ExtensionManager
sudo dnf -y install gnome-shell-extension-user-theme
sudo dnf -y install gnome-shell-extension-just-perfection
```
### Bash Configuration Examples
A specific bash script will be very user and preference specific, but here are some examples.  Ordering is somewhat important here as you obviously can't point to a theme that's not installed yet, and some of this is redudant if your /home is it's own partition so that clean installs don't modify it.  Your mileage may vary.
```
Cloning some Github repos:
git clone https://github.com/vinceliuice/WhiteSur-icon-theme ~/Documents/Software/Git/WhiteSur-icon-theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme ~/Documents/Software/Git/WhiteSur-gtk-theme
```
Installing some GTK and icon themes:
```
sudo dnf -y install gnome-tweaks adw-gtk3-theme yaru-theme
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean
```
Command line controls of Gnome Tweaks (you can use 'dconf watch /' to get syntax for these):
```
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
gsettings set org.gnome.shell.extensions.user-theme name 'MacLight'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close:appmenu'
```
Command line controls of Just Perfection (this snippet moves the clock and notification to the right):
```
gsettings set org.gnome.shell.extensions.just-perfection clock-menu-position 1
gsettings set org.gnome.shell.extensions.just-perfection clock-menu-position-offset 6
gsettings set org.gnome.shell.extensions.just-perfection notification-banner-position 2
```
Install some applications in different ways, this list can be as long as your requirements:
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf -y install google-chrome-stable_current_x86_64.rpm  # Grab Google Chrome's latest and install locally
flatpak -y install flathub io.github.shiftey.Desktop  # Github Desktop, syntax found via Flathub's web install
flatpak -y install flathub zoom geary  # Multi install for built in apps, specifying Flathub as the repo
```
Any custom configuration (my icon set is a mix of about three different Mac-like themes)
```
tar -C $HOME/.icons -xvf $HOME/.icons/WhiteSurCustom.tar.xz
rsync -a -v --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
tar -czf $HOME/.icons/WhiteSurCustom.tar.xz WhiteSur
```
These examples are geared to Fedora for syntax but other distros would be similar (Ubuntu would use apt as the package manager instead of dnf, sandboxed apps would default to snap without explicitly installed Flatpak support, etc).  Real bash shell example coming soon.