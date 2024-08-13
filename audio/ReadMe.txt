alsa-base.conf contains driver loading changes to get the bass speakers of a Lenovo Yoga 9 (Intel) to work in Ubuntu.

Creating snd.conf and putting it into /etc/modprobe.d/ is all that's required on newer kernels. Works on Manjaro, Ubuntu as of 23.10, and Fedora 39.  Possibly even further back.

Here's a good resource for this model https://github.com/PJungkamp/yoga9-linux
