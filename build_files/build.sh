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
dnf -y install ublue-os-libvirt-workarounds ublue-os-selinux-workarounds ublue-os-signing ublue-motd bazaar ublue-os-media-automount-udev krunner-bazaar uupd
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
dnf -y install vlc ffmpeg flatpak podman podman-compose distrobox fastfetch uv git syncthing --skip-unavailable --skip-broken
dnf -y install wayland-devel libwayland-client
echo "--- installing KDE/GNOME apps --"
dnf -y install koko gnome-disk-utility gnome-text-editor gnome-system-monitor --skip-unavailable --skip-broken
# Install Gaming Stuff
echo "--- installing Gaming Utilities/Tools... ---"
dnf -y install steam protonplus protontricks gamemode --skip-unavailable --skip-broken
dnf -y install powerbuttond inputplumber --skip-unavailable --skip-broken
dnf -y install gamescope --skip-unavailable --skip-broken
dnf -y install gamemode mangohud --skip-unavailable --skip-broken

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

# Install Tailscale - Should be available in brew now
# curl -fsSL https://tailscale.com/install.sh | sh

# ----------------------------
# ---- Copy System Files -----
# ----------------------------
# Copy all files to root directory
cp -avf "/ctx/system_files/shared"/. /

# ---------------------------
# ------- SystemD ----------=
# ---------------------------

# podman
systemctl enable podman.socket

# libvirtd
systemctl enable libvirtd

# Disable Abrupt Automatic updates with a systemd mask 
systemctl mask bootc-fetch-apply-updates.service bootc-fetch-apply-updates.timer

# ---------------------------
# ----- Extra Utilities  ----
# ---------------------------

# Topgrade
dnf5 -y install topgrade
