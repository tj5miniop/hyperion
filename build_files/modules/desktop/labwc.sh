#!/bin/bash
# Set error handling and load utilities
set -euo pipefail
source build_files/lib/utils.sh

# Install Base Desktop (Labwc) packages
log_info "Installing Labwc base desktop packages..."
dnf5 -y install \
    NetworkManager xorg-x11-server-Xwayland wayland-utils \
    quickshell labwc labwc-session alacritty git polkit polkit-kde kernel-tools-libs kernel-tools kernel-modules kernel-modules-extra sassc xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk jetbrains-mono-fonts-all

# Install Noctalia
log_info "Installing Noctalia..."
dnf5 -y install noctalia-nightly

# Install theming and dotfile tools
log_info "Installing theme/dotfile utilities (lxappearance, kvantum, stow)..."
dnf5 -y install lxappearance kvantum stow

# Install ZSH
log_info "Installing ZSH..."
dnf5 -y install zsh

# Install additional apps and services
log_info "Installing thunar, pipewire, bluez, and NetworkManager-tui..."
dnf5 -y install thunar pipewire wireplumber bluez bluez-tools NetworkManager-tui

# Install Login Manager (Ly) and enable services
log_info "Setting up Ly login manager..."
dnf5 -y install ly
systemctl enable NetworkManager
systemctl set-default graphical.target
systemctl enable ly@tty1

# Install Themes (GTK, Cursor, Icons)
log_info "Installing themes via git clones..."
WORK_DIR_DOTS=/tmp/dots/
mkdir -p "$WORK_DIR_DOTS"
cd "$WORK_DIR_DOTS"

# GTK Theme
git clone https://github.com/vinceliuice/Colloid-gtk-theme && \
  (cd Colloid-gtk-theme && sudo ./install.sh --tweaks nord)

# Cursor Theme
git clone https://github.com/vinceliuce/Vimix-cursors && \
  (cd Vimix-cursors && sudo ./install.sh)

# Icon Theme
git clone https://github.com/vinceliuce/WhiteSur-icon-theme && \
  (cd WhiteSur-icon-theme && sudo ./install.sh -t purple -a)

# Cleanup theme directory and copy files to system
log_info "Finalizing Labwc setup..."
rm -rf "$WORK_DIR_DOTS"
cp -avf "/ctx/system_files/labwc"/. /

# Final cleanup
dnf5 -y clean all
log_success "Labwc module complete."
