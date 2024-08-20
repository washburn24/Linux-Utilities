# Linux Utilities
 Some utilities for Linux/Gnome to automate the path between clean install and useful system.

### Overview
These tools are designed to make clean installs of Linux/Gnome enviroments automated including installing applications, cloning Github repos, installing themes and automatically controlling them via Tweaks and Themes.  There is also some custom configuration that can be easily automatically controlled.  My system is skinned to look like Mac OS with default Adwaita window controls, but any theme/icon combo would work in a similar way.  Note that installing themes programatically requires a reload of Gnome Shell (a logout on Wayland) and makes them non-User Installed, which I don't really like.  Distros that don't have Flatpak preinstalled (like Debian) also require configuring before the Flatpak portions of this scripting will work.  So, at current I'm manually configuring a minimal set of commands that really should be done from the command line (like the below) but can't be unless you're on an older WM:

```
flatpak -y install flathub ExtensionManager
sudo dnf -y install gnome-shell-extension-user-theme
sudo dnf -y install gnome-shell-extension-just-perfection
```
### Bash Configuration Examples
A specific bash script will be very user and preference specific, but here are some examples.  Ordering is somewhat important here as you obviously can't point to a theme that's not installed yet, and some of this is redudant if your /home is it's own partition so that clean installs don't have to format it, but that redudancy is fine and won't interrupt the script.  Your mileage may vary by distro and user specific requirements.

Cloning some Github repos:
```
git clone https://github.com/vinceliuice/WhiteSur-icon-theme $HOME/Documents/Software/Git/WhiteSur-icon-theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/Documents/Software/Git/WhiteSur-gtk-theme
git clone https://github.com/washburn24/Linux-Utilities $HOME/Documents/Linux-Utilities
```
Installing some GTK and icon themes:
```
sudo dnf -y install gnome-tweaks adw-gtk3-theme yaru-theme
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -a -d $HOME/.icons -n WhiteSurAlt
$HOME/Documents/Software/Git/WhiteSur-icon-theme/install.sh -d $HOME/.icons -n WhiteSurClean
```
Command line controls of Gnome settings (you can use 'dconf watch /' to get syntax for gsettings set commands):
```
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll 'false'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'
gsettings set org.gnome.desktop.control-center window-state 'uint32 0'
```
Command line controls of Gnome Tweaks:
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
Any custom configuration or known bug fixes for specific hardware:
```
tar -C $HOME/.icons -xvf $HOME/.icons/WhiteSurCustom.tar.xz
rsync -a -v --ignore-existing $HOME/.icons/WhiteSurClean/* $HOME/.icons/WhiteSur/
sudo cp -f $HOME/Documents/Linux-Utilities/audio/snd.conf /etc/modprobe.d/
```
These examples are geared to Fedora for syntax and clean install toolset but other distros would be similar (Debian would use apt as the package manager instead of dnf, Ubuntu would do that as well as having sandboxed apps default to Snap without explicitly installed Flatpak support, etc).  A functional bash shell example for Fedora Workstation 40 and Ubuntu 24.02 LTS are in the /tools subdirectory, everything they need is self contained in public git repos including this one, which it will clone automatically.  They aren't perfect but are a good start.