#!/bin/bash
# Set error handling and load utilities
set -euo pipefile
source build_files/lib/utils.sh

# Install KDE base packages
log_info "Installing KDE base packages..."
dnf -y install ghostty kvantum

# Remove default KDE-bundled packages
log_info "Removing native KDE packages..."
dnf -y remove \
    firefox \
    konsole \
    gwenview \
    haruna \
    kwrite \
    kate \
    plasma-systemmonitor

# Install Papirus Icons
log_info "Installing Papirus icons..."
dnf5 -y install papirus-icon-theme

# Install Layan theme (Credit: Vinceliuice)
log_info "Installing Layan KDE theme..."
DIR_THEMES=/tmp/themes/
REPO_NAME=Layan-kde
mkdir -p "$DIR_THEMES" && cd "$DIR_THEMES"
git clone https://github.com/vinceliuice/"$REPO_NAME" && cd "$REPO_NAME"
bash ./install.sh

# Copy KDE system files to root directory
log_info "Copying KDE configuration files..."
cp -avf "/ctx/system_files/kde"/. /

log_success "KDE module complete."
