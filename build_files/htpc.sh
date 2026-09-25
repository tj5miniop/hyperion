#!/usr/bin/bash
# Hyperion HTPC edition (couch-gaming focused)
#
# NOTE: package names are from memory and depend on which repos your base
# image enables (Fedora, RPM Fusion, the Bazzite COPRs). Verify each with:
#   dnf repoquery <name>
set -euxo pipefail

# Copy system files - NOT NEEDED AS OF NOW AS IT USES THE ASUS FILES
#cp -avf "/ctx/system_files/htpc"/. /

dnf -y install \
    gamescope-session-steam \
    gamescope-session \
    inputplumber

# Controllers and gaming utilities
dnf -y install \
    8bitdo-udev-rules

# Networking Tools
dnf -y install \
    cifs-utils \
    nfs-utils \
    openssh-server

# Cleanup
dnf clean all
