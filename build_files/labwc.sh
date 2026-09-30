#!/bin/bash
set -ouex pipefail


# Quickshell
dnf5 -y copr enable errornointernet/quickshell
dnf5 -y install \
    ly NetworkManager xorg-x11-server-Xwayland wayland-utils \
    quickshell labwc labwc-session alacritty git polkit polkit-kde kernel-tools-libs kernel-tools wofi sassc xdg-desktop-portal xdg-desktop-portal-wlr
dnf5 -y copr disable errornointernet/quickshell

# Noctalia
dnf5 -y install noctalia

# Install theming apps
dnf5 -y install lxappearance kvantum
# Install dotfiles related tools
dnf5 -y install stow
# Install other apps
dnf5 -y install thunar pipewire wireplumber bluez bluez-tools NetworkManager-tui

# Enable SystemD Stuff
systemctl enable NetworkManager
systemctl enable ly@tty1
systemctl set-default graphical.target

# Install dotfiles - REMOVED - now replaced with Themes
$WORK_DIR_DOTS = /tmp/dots/
mkdir -p $WORK_DIR_DOTS
cd $WORK_DIR_DOTS
# Install GTK Theme
git clone https://github.com/vinceliuice/Colloid-gtk-theme && \
  (cd Colloid-gtk-theme && sudo ./install.sh --tweaks nord)

# Install Cursor Theme
git clone https://github.com/vinceliuice/Vimix-cursors && \
  (cd Vimix-cursors && sudo ./install.sh)

# Install Icon theme
git clone https://github.com/vinceliuice/WhiteSur-icon-theme && \
  (cd WhiteSur-icon-theme && sudo ./install.sh -t purple -a)

# Return back to root
cd /
rm -rf "$WORK_DIR_DOTS"

# Copy LABWC files to system
cp -avf "/ctx/system_files/labwc"/. /
