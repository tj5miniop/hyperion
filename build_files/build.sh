#!/bin/bash
# Ensure that if any errors occur, the script will stop
set -euo pipefail

# Load utility functions
source lib/utils.sh

log_info "Starting Hyperion base build..."

# Install dnf plugins 
dnf -y install dnf5-plugins gh

# Update and configure Universal Blue fixes
log_info "Updating/Configuring Universal Blue fixes..."
dnf -y copr enable ublue-os/packages
dnf -y install ublue-os-libvirt-workarounds ublue-os-selinux-workarounds ublue-os-signing ublue-motd bazaar ublue-os-media-automount-udev
dnf copr enable ublue-os/packages

# Install SELinux fixes
log_info "Installing SELINUX FIXES..."
dnf -y install selinux-policy-targeted

# Enable Terra repo
log_info "Enabling Terra repo..."
dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf -y install terra-release-extras

# Install base packages
log_info "Installing base packages..."
dnf -y install vlc ffmpeg flatpak podman podman-compose distrobox fastfetch uv git zed-nightly syncthing helium-browser-bin
dnf -y install wayland-devel libwayland-client

# Install KDE/GNOME apps
log_info "Installing KDE/GNOME apps..."
dnf -y install koko gnome-disk-utility gnome-text-editor gnome-system-monitor

# Install Gaming Utilities/Tools
log_info "Installing Gaming Utilities/Tools..."
dnf -y install steam protonplus protontricks gamemode
dnf -y install powerbuttond inputplumber
dnf -y install gamescope
dnf -y install gamemode mangohud

# Install python devel packages
log_info "Installing Python development packages..."
dnf -y install python3.14 python3.14-devel

# Install Virtualisation Tools
log_info "Installing Virtualisation Tools..."
dnf -y install virt-manager libvirt qemu edk2-ovmf swtpm

# Installing CachyOS addons
log_info "Installing CachyOS addons..."
dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y swap zram-generator-defaults cachyos-settings
dnf -y install power-profiles-daemon --allowerasing
dnf -y install scx-manager scx-scheds scx-tools
dnf -y copr disable bieszczaders/kernel-cachyos-addons

# AppImage Support rework
log_info "Setting up AppImage support..."
dnf -y install fuse fuse3 fuse-libs fuse3-libs

# Install Tailscale
log_info "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# Copy system files to root directory
log_info "Copying shared system files to root..."
cp -avf "/ctx/system_files/shared"/. /

# Install misc RPMs (Heroic, Hydra, Faugus)
log_info "Installing gaming-related RPMs..."
HEROIC_VER=2.22.3
HYDRA_VER=4.1.5
FAUGUS_VER=2.4.2
DIR_RPMS=/tmp/local-rpms/
mkdir -p $DIR_RPMS
cd "$DIR_RPMS" || exit 1

curl -L https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v$HEROIC_VER/Heroic-$HEROIC_VER-linux-x86_64.rpm --output heroic.rpm
curl -L https://github.com/hydralauncher/hydra/releases/download/v$HYDRA_VER/hydralauncher-$HYDRA_VER.x86_64.rpm --output hydra.rpm
curl -L https://github.com/Faugus/faugus-launcher/releases/download/$FAUGUS_VER/faugus-launcher-$FAUGUS_VER-1.fc44.noarch.rpm --output faugus.rpm

dnf -y install ./*.rpm --allowerasing --skip-broken

# Enable SystemD services
log_info "Enabling systemd units..."
systemctl enable podman.socket
systemctl enable libvirtd

# Install Topgrade
log_info "Installing topgrade..."
dnf5 -y install topgrade

log_success "Base build complete."
