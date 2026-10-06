#!/bin/bash
# Set error handling and load utilities
set -euo pipefail
source build_files/lib/utils.sh

# Install ASUS-specific packages and Waydroid
log_info "Installing ASUS CTL and Waydroid..."
dnf5 -y install asusctl asusctl-rog-gui waydroid

# Enable Waydroid helper via COPR
log_info "Enabling Waydroid helper..."
dnf5 -y copr enable cuteneko/waydroid-helper
dnf -y install waydroid-helper

# Enable ASUS systemd services
log_info "Enabling ASUS systemd units..."
systemctl enable asusd.service
systemctl enable asus-shutdown.service

# Copy ASUS specific files to root directory
log_info "Copying ASUS configuration files..."
cp -avf "/ctx/system_files/asus"/. /

log_success "ASUS module complete."
