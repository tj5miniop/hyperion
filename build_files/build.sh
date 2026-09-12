#!/bin/bash
# Ensure that if any errors occur, the script will stop
set -ouex pipefail

echo "
 _    ___  _ ____  _____ ____  _  ____  _
/ \ /|\  \///  __\/  __//  __\/ \/  _ \/ \  /|
| |_|| \  / |  \/||  \  |  \/|| || / \|| |\ ||
| | || / /  |  __/|  /_ |    /| || \_/|| | \||
\_/ \|/_/   \_/   \____\\_/\_\\_/\____/\_/  \|
"

# New modularised way to show certain parts on the installation in logs
run_section() {
    local section_name="$1"
    shift
    echo "========================================"
    echo ">>> $section_name <<<"
    echo "========================================"
    "$@"
}

# Install Steps

# Base system/apps
install_base() {
    echo "--- Installing Base System Packages ---"
    dnf -y install ghostty equibop vlc ffmpeg flatpak podman distrobox fastfetch uv git zed
}

# GNOME/KDE apps
install_desktop_apps() {
    echo "--- Installing KDE/GNOME Apps ---"
    dnf -y install koko gnome-disk-utility gnome-text-editor gnome-system-monitor
}

# Gaming Stuff
install_gaming_tools() {
    echo "--- Installing Gaming Utilities/Tools ---"
    # Grouped powerbuttond and inputplumber with the other gaming tools for better grouping
    dnf -y install steam protonplus protontricks gamemode powerbuttond inputplumber gamescope-session gamescope-session-ogui-steam gamescope steamos-manager steam-notif-daemon
}




# Main section
# Enable Terra repository - DO NOT MOVE AS TERRA NEEDS TO BE ENABLED FIRST
run_section "Terra Repository Setup" install_pkgs --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-release-extras # Combined enable/install for Terra repo

# Install certain ublue-fixes
echo "--- Updating/Configuring Universal Blue fixes... ---"
dnf -y copr enable ublue-os/packages
install_pkgs \
    ublue-os-libvirt-workarounds \
    ublue-os-selinux-workarounds \
    ublue-os-signing \
    ublue-motd \
    bazaar \
    ublue-os-media-automount-udev

run_section "SELinux Fixes" install_pkgs selinux-policy-targeted

# Remove certain bundled packages
echo " --- Removing certain native packages... ---"
dnf -y remove \
    firefox \
    konsole \
    gwenview \
    haruna \
    kwrite \
    kate \
    plasma-systemmonitor \

# Base Packages
run_section "Base Packages" install_base

# Install desktop apps
run_section "Desktop Applications" install_desktop_apps

# Install gaming tools
run_section "Gaming Utilities/Tools" install_gaming_tools

# ds-inhibit setup
echo "--- Installing ds-inhibit ---"
dnf -y copr enable bazzite-org/bazzite
install_pkgs ds-inhibit
dnf -y copr disable bazzite-org/bazzite

# Install Virtualisation Tools
run_section "Virtualisation Tools" install_pkgs virt-manager libvirt qemu edk2-ovmf

# Zen browser setup
echo "--- Installing Zen Browser... ---" # Kept the echo for this specific step
dnf -y copr enable sneexy/zen-browser
install_pkgs zen-browser
dnf -y copr disable sneexy/zen-browser

# CachyOS addons
run_section "CachyOS Addons" install_pkgs \
    swap zram-generator-defaults cachyos-settings power-profiles-daemon --allowerasing scx-manager scx-scheds scx-tools

# AppImage Support
run_section "AppImage Support" install_pkgs fuse fuse3

# Theming
echo "--- Installing Papirus Icon Theme ---"
dnf5 -y install papirus-icon-theme

# Copy System Files
run_section "Copying MAIN System Files (anything else will be done on a per image basis)" cp -avf "/ctx/system_files/shared"/. /

# Install misc RPMs
echo "--- Installing Misc/External RPMs ---"
HEROIC_VER=2.22.1 # Source https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher
HYDRA_VER=4.1.3 # Source https://github.com/hydralauncher/hydra/
FAUGUS_VER=2.2.2 # Source https://github.com/Faugus/faugus-launcher
DIR_RPMS=/tmp/local-rpms/
mkdir -p "$DIR_RPMS" # Added quotes for robustness
cd "$DIR_RPMS" || exit 1

curl -L https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v$HEROIC_VER/Heroic-$HEROIC_VER-linux-x86_64.rpm --output heroic.rpm
curl -L https://github.com/hydralauncher/hydra/releases/download/v$HYDRA_VER/hydralauncher-$HYDRA_VER.x86_64.rpm --output hydra.rpm
curl -L https://github.com/Faugus/faugus-launcher/releases/download/$FAUGUS_VER/faugus-launcher-$FAUGUS_VER-1.fc44.noarch.rpm --output faugus.rpm

dnf -y install ./*.rpm --allowerasing

# SystemD Services
run_section "Enable SystemD services" \
    systemctl enable podman.socket \
    libvirtd \
    ds-inhibit

echo "DONE!"
