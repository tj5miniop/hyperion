#!/bin/bash

dnf5 -y install ly NetworkManager xorg-x11-server-xwayland egl-wayland wayland-utils quickshell labwc alacritty git polkit polkit-gnome

# Install dotfiles - possibly install them to skel and implement a ujust dotfiles-update command to update the dots
WORK_DIR_DOTS = /tmp/dots/
mkdir -p $WORK_DIR_DOTS && cd $WORK_DIR_DOTS
git clone https://github.com/tj5miniop/tj5-de/
# Copy to Skel
cd tj5-de && cp -r .config/ /etc/skel/

# Return back to root
cd /

# Copy LABWC files to system
# Copy all files to root directory
cp -avf "/ctx/system_files/labwc"/. /
