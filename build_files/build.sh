#!/bin/bash
# Ensure that if any errors occur, the script will stop
set -ouex pipefail

WINBOAT_VER="0.9.2"
TMP_RPM_INS="/tmp/rpms/installer"

# Enable podman.socket
systemctl enable podman.socket

# Install certain ublue-fixes
dnf -y copr enable ublue-os/packages
dnf -y install ublue-* ublue-os-libvirt-workarounds ublue-os-selinux-workarounds
dnf copr enable ublue-os/packages

# Remove certain bundled packages
dnf -y remove \
    firefox

# Enable Terra repo
dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Configure terra repo
dnf -y install terra-release-extras

# Install packages
dnf -y install steam heroic-games-launcher protonplus flatpak protontricks