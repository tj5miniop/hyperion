#!/bin/bash

# HYPERION GNOME EDITION BUILD SCRIPT - Very Bare Bones at the moment
dnf5 -y remove gnome-software firefox


# GNOME DESKTOP CUSTOMIZATIONS

# Exntensions
dnf5 -y install --skip-unavailable \
  gnome-tweaks \
  gnome-shell-extensions \
  gnome-shell-extensions-common \
  gnome-shell-extension-caffeine \
  gnome-shell-extension-just-perfection \
  gnome-shell-extension-dash-to-dock \
  sassc \


# Theme installation

# Install GTK Theme
git clone https://github.com/vinceliuice/Colloid-gtk-theme && \
  (cd Colloid-gtk-theme && sudo ./install.sh --tweaks nord)

# Install Cursor Theme
git clone https://github.com/vinceliuice/Vimix-cursors && \
  (cd Vimix-cursors && sudo ./install.sh)

# Install Icon theme
git clone https://github.com/vinceliuice/WhiteSur-icon-theme && \
  (cd WhiteSur-icon-theme && sudo ./install.sh -t purple -a)


cd /tmp
