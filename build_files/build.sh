#!/bin/bash
# Ensure that if any errors occur, the script will stop
set -ouex pipefail

WINBOAT_VER="0.9.2"
TMP_RPM_INS="/tmp/rpms/installer"

# podman and distrobox configuration
dnf -y install podman distrobox

systemctl enable podman.socket

# Install certain ublue-fixes
dnf -y copr enable ublue-os/packages
dnf -y install ublue-os-libvirt-workarounds ublue-os-selinux-workarounds ublue-os-signing ublue-motd bazaar ublue-os-media-automount-udev
dnf copr enable ublue-os/packages

# Remove certain bundled packages
dnf -y remove \
    firefox \
    konsole \

# Enable Terra repo
dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Configure terra repo
dnf -y install terra-release-extras

# Install packages
dnf -y install steam heroic-games-launcher protonplus flatpak protontricks ghostty codium equibop

# AppImage Support rework
dnf -y install fuse fuse3