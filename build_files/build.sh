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

# Remove certain bundled packages
echo " --- Removing certain native packages... ---"
dnf -y remove \
    firefox \
    konsole \

# Enable Terra repo
dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Configure terra repo
dnf -y install terra-release-extras

# Install base packages
echo "--- installing base packages... ---"
dnf -y install ghostty codium equibop vlc ffmpeg flatpak podman distrobox fastfetch gnome-disk-utility uv git

# Install Gaming Stuff
echo "--- installing Gaming Utilities/Tools... ---"
dnf -y install steam protonplus protontricks gamemode 


# Install Virtualisation Tools
echo "--- Installing Virtualisation Tools... ---"
dnf -y install virt-manager libvirt qemu edk2-ovmf

# install Zen browser (https://zen-browser.app/)
echo "--- Installing Zen Browser... ---"
dnf -y copr enable sneexy/zen-browser
dnf -y install zen-browser
dnf -y copr disable sneexy/zen-browser


# AppImage Support rework
dnf -y install fuse fuse3

# ---------------------------
# ------- Theming -----------
# ---------------------------
# This section of the script does not directly set up the dotfiles but will install all dependencies
# Papirus Icons
dnf5 -y install papirus-icon-theme

# ----------------------------
# ---- Copy System Files -----
# ----------------------------
# Copy all files to root directory
cp -avf "/ctx/system_files"/. /


# ---------------------------
# - Copy First Setup Script -
# ---------------------------
SETUP_DIR="/tmp/hyperion/setup"
GIT_REPO_SETUP="https://github.com/tj5miniop/hyperion-first-setup"
DEST_DIR="/usr/share/hyperion-setup"

# clone git repo 
mkdir -p "$SETUP_DIR"
cd "$SETUP_DIR"
git clone "$GIT_REPO_SETUP" hyperion-first-setup
cd hyperion-first-setup

# Copy directory contents safely
mkdir -p "$DEST_DIR"
cp -a setup/. "$DEST_DIR/"

# ----------------------------
# --- Install misc RPMs ------
# ----------------------------

# Disclaimer
# HYDRA Launcher is installed here, as it's one of the best "one-stop-shop" game launchers I can find for Linux (essentially like playnite)
#It has some piracy-related features just to be aware - I am distributing this as part of hyperion NOT for anything related to piracy
HEROIC_VER=2.22.1 # Source https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher
HYDRA_VER=4.1.2 # Source https://github.com/hydralauncher/hydra/
FAUGUS_VER=2.2.1 # Source https://github.com/Faugus/faugus-launcher
DIR_RPMS=/tmp/local-rpms/
mkdir -p $DIR_RPMS
cd "$DIR_RPMS" || exit 1

curl -L https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v$HEROIC_VER/Heroic-$HEROIC_VER-linux-x86_64.rpm --output heroic.rpm
curl -L https://github.com/hydralauncher/hydra/releases/download/v$HYDRA_VER/hydralauncher-$HYDRA_VER.x86_64.rpm --output hydra.rpm
curl -L https://github.com/Faugus/faugus-launcher/releases/download/$FAUGUS_VER/faugus-launcher-$FAUGUS_VER-1.fc44.noarch.rpm --output faugus.rpm

dnf -y install ./*.rpm --allowerasing


# ---------------------------
# ------- SystemD ----------=
# ---------------------------

# podman
systemctl enable podman.socket

# libvirtd
systemctl enable libvirtd

