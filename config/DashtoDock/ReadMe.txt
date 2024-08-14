At some point DashtoDock seemingly started taking control of more visual parameters, making some of them more difficult/possibly ignored in the gnome-shell .css, so this file hard codes little to no spacing around launcher icons to preserve a very compact dock look.  There have to be better ways to do this but scroll to the end for the brute force method.

This file replaces (or appends the last routine to) stylesheet.css in the DashtoDock install location, commonly ~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
