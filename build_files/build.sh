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

# Install dnf plugins 
dnf -y install dnf5-plugins gh

# ----------------------------
# -------- DNF Stuff ---------
# ----------------------------

# Install certain ublue-fixes
echo "--- Updating/Configuring Universal Blue fixes... ---"
dnf -y copr enable ublue-os/packages
dnf -y install ublue-os-libvirt-workarounds ublue-os-selinux-workarounds ublue-os-signing ublue-motd bazaar ublue-os-media-automount-udev
dnf copr enable ublue-os/packages

# Installing SElinux-Fixes
echo "--- installing SELINUX FIXES... ---"
dnf -y install selinux-policy-targeted

# Enable Terra repo
dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Configure terra repo
dnf -y install terra-release-extras

# Install base packages
echo "--- installing base packages... ---"
dnf -y install vlc ffmpeg flatpak podman podman-compose distrobox fastfetch uv git zed-nightly syncthing helium-browser-bin
dnf -y install wayland-devel libwayland-client
echo "--- installing KDE/GNOME apps --"
dnf -y install koko gnome-disk-utility gnome-text-editor gnome-system-monitor
# Install Gaming Stuff
echo "--- installing Gaming Utilities/Tools... ---"
dnf -y install steam protonplus protontricks gamemode
dnf -y install powerbuttond inputplumber
dnf -y install gamescope
dnf -y install gamemode mangohud

# install python devel packages
dnf -y install \
    python3.14 \
    python3.14-devel \

# Install Virtualisation Tools
echo "--- Installing Virtualisation Tools... ---"
dnf -y install virt-manager libvirt qemu edk2-ovmf swtpm

# Installing CachyOS addons
dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y swap zram-generator-defaults cachyos-settings
# Install certain dependencies
dnf -y install power-profiles-daemon --allowerasing
dnf -y install scx-manager scx-scheds scx-tools
dnf -y copr disable bieszczaders/kernel-cachyos-addons

# AppImage Support rework
dnf -y install fuse fuse3 fuse-libs fuse3-libs

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# ----------------------------
# ---- Copy System Files -----
# ----------------------------
# Copy all files to root directory
cp -avf "/ctx/system_files/shared"/. /
# ----------------------------
# --- Install misc RPMs ------
# ----------------------------

# Disclaimer
# Heroic Games Launcher - Allows for Epic Games, Amazon and GOG games
# Faugus - Allows for standalone games/apps or other launchers to be installed
# Hydra Launcher - has similar functionality to Faugus but has achievments, optional paid cloud saves: based on my testing, some games work better on here on Faugus

HEROIC_VER=2.22.3 # Source https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher
HYDRA_VER=4.1.5 # Source https://github.com/hydralauncher/hydra/
FAUGUS_VER=2.4.2 # Source https://github.com/Faugus/faugus-launcher
DIR_RPMS=/tmp/local-rpms/
mkdir -p $DIR_RPMS
cd "$DIR_RPMS" || exit 1

curl -L https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v$HEROIC_VER/Heroic-$HEROIC_VER-linux-x86_64.rpm --output heroic.rpm
curl -L https://github.com/hydralauncher/hydra/releases/download/v$HYDRA_VER/hydralauncher-$HYDRA_VER.x86_64.rpm --output hydra.rpm
curl -L https://github.com/Faugus/faugus-launcher/releases/download/$FAUGUS_VER/faugus-launcher-$FAUGUS_VER-1.fc44.noarch.rpm --output faugus.rpm

dnf -y install ./*.rpm --allowerasing --skip-broken

# ---------------------------
# ------- SystemD ----------=
# ---------------------------

# podman
systemctl enable podman.socket

# libvirtd
systemctl enable libvirtd


# ---------------------------
# ----- Extra Utilities  ----
# ---------------------------

# Topgrade
dnf5 -y install topgrade
