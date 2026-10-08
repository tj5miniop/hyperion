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

# Install WhiteSur for GNOME
echo "--- Whitesur GTK Theme - CREDIT VINCELLUICE ---"
DIR_Themes=/tmp/themes/
WS_REPO_NAME=WhiteSur-gtk-theme
mkdir -p $DIR_Themes && cd $DIR_Themes
git clone https://github.com/vinceliuice/"$WS_REPO_NAME" && cd $WS_REPO_NAME
bash ./install.sh -c dark -a alt -t purple -m -s nord -l -N glassy

# Install Colloid-Icon-Theme
echo "--- Colloid Icon Theme - CREDIT VINCELLUICE ---"
CL_REPO_NAME=Colloid-icon-theme
mkdir -p $DIR_Themes && cd $DIR_Themes
git clone https://github.com/vinceliuice/"$CL_REPO_NAME" && cd $CL_REPO_NAME
bash ./install.sh -s nord -t purple



cd /tmp
