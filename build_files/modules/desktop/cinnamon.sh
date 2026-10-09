#!/bin/bash
set -ouex pipefail


# Base Desktop
dnf5 -y install \
    NetworkManager xorg-x11-server-Xwayland wayland-utils \
    git polkit polkit-kde kernel-tools-libs kernel-tools kernel-modules kernel-modules-extra sassc xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk jetbrains-mono-fonts-all

# Install cinnamon
dnf5 -y install cinnamon cinnamon-themes cinnamon-desktop nemo cinnamon-menus lightdm lightdm-slick-greeter mint-themes


# Install dotfiles related tools
dnf5 -y install stow

# Install ZSH
dnf5 -y install zsh

# Install other apps
dnf5 -y install thunar pipewire wireplumber bluez bluez-tools NetworkManager-tui

# Enable SystemD Stuff
systemctl enable NetworkManager
systemctl set-default graphical.target
systemctl enable lightdm

cd /tmp

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


# Copy LABWC files to system
cp -avf "/ctx/system_files/labwc"/. /


# Cleanup

dnf5 -y clean all
