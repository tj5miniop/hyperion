#!/bin/bash
set -ouex pipefail

# Base System Utilities & Fonts
dnf5 -y install \
    NetworkManager git polkit kernel-tools \
    kernel-modules kernel-modules-extra xdg-desktop-portal-gtk \
    jetbrains-mono-fonts-all stow zsh thunar pipewire wireplumber bluez gdm \

# Cinnamon DE
dnf5 -y group install cinnamon-desktop-environment

# Enable Systemd Services (
systemctl enable NetworkManager
systemctl enable gdm 
systemctl set-default graphical.target

# Cleanup
dnf5 -y clean all
