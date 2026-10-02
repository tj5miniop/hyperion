#!/bin/bash
set -ouex pipefail


# Base Desktop (Labwc)
dnf5 -y install \
    NetworkManager xorg-x11-server-Xwayland wayland-utils \
    quickshell labwc labwc-session alacritty git polkit polkit-kde kernel-tools-libs kernel-tools sassc xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk jetbrains-mono-fonts-all
# Noctalia
dnf5 -y install noctalia-nightly
# Install theming apps
dnf5 -y install lxappearance kvantum
# Install dotfiles related tools
dnf5 -y install stow

# Install ZSH
dnf5 -y install zsh

# Install other apps
dnf5 -y install thunar pipewire wireplumber bluez bluez-tools NetworkManager-tui

# Install Login Manager
dnf5 -y install ly
# Enable SystemD Stuff
systemctl enable NetworkManager
systemctl set-default graphical.target
systemctl enable ly@tty1
# Install dotfiles - REMOVED - now replaced with Themes
WORK_DIR_DOTS=/tmp/dots/
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


# Cleanup

dnf5 -y clean all
