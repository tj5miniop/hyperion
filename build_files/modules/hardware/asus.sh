#!/bin/bash

# Terra Repo is enabled in the previous build.sh
# UPDATE - added asusctl-rog-gui for a nice GUI
dnf5 -y install asusctl asusctl-rog-gui waydroid

dnf5 -y copr enable cuteneko/waydroid-helper
dnf -y install waydroid-helper

# Add systemd units
systemctl enable asusd.service
systemctl enable asus-shutdown.service

echo " --- Asus CTL added ---"

# Install ASUS specific files
# Copy all files to root directory
cp -avf "/ctx/system_files/asus"/. /
