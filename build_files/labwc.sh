#!/bin/bash
set -ouex pipefail

dnf5 -y copr enable errornointernet/quickshell
dnf5 -y install \
    ly NetworkManager xorg-x11-server-Xwayland wayland-utils \
    quickshell labwc alacritty git polkit polkit-kde
dnf5 -y copr disable errornointernet/quickshell

# Enable SystemD Stuff
systemctl enable NetworkManager
systemctl enable ly@tty1
systemctl set-default graphical.target

# Install dotfiles - possibly install them to skel and implement a ujust dotfiles-update command to update the dots
WORK_DIR_DOTS=/tmp/dots/
mkdir -p "$WORK_DIR_DOTS" && cd "$WORK_DIR_DOTS"
git clone --depth 1 https://github.com/tj5miniop/tj5-de/
# Copy to Skel, for any user created after first boot...
cp -r tj5-de/.config/ /etc/skel/
# ...and to root
cp -r tj5-de/.config/ /root/
# Return back to root
cd /
rm -rf "$WORK_DIR_DOTS"

# Copy LABWC files to system
cp -avf "/ctx/system_files/labwc"/. /
