#!/bin/bash
# Set error handling and load utilities
set -euo pipefail
source build_files/lib/utils.sh

# Remove default GNOME packages
log_info "Removing default GNOME software..."
dnf5 -y remove gnome-software firefox

# Install WhiteSur GTK Theme (Credit: Vinceliuice)
log_info "Installing WhiteSur GTK theme..."
DIR_THEMES=/tmp/themes/
WS_REPO=WhiteSur-gtk-theme
mkdir -p "$DIR_THEMES" && cd "$DIR_THEMES"
git clone https://github.com/vinceliuice/"$WS_REPO" && cd "$WS_REPO"
bash ./install.sh -c dark -a alt -t purple -m -s nord -l -N glassy

# Install Colloid Icon Theme (Credit: Vinceliuice)
log_info "Installing Colloid icon theme..."
CL_REPO=Colloid-icon-theme
mkdir -p "$DIR_THEMES" && cd "$DIR_THEMES"
git clone https://github.com/vinceliuice/"$CL_REPO" && cd "$CL_REPO"
bash ./install.sh -s nord -t purple

# Cleanup temporary theme directory
log_info "Cleaning up themes..."
cd /tmp
rm -rf "$DIR_THEMES"

log_success "GNOME module complete."
