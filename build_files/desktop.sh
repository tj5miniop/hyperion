#!/bin/bash
#
# Hyperion Desktop Edition (KDE) files - any app/setting not present in LABWC lives here
# Very Minimal at the MOMENT
#

# Install base packages
echo "--- installing KDE base packages... --- - KDE EDITION"
dnf -y install ghostty kvantum
echo "--- installing KDE/GNOME apps -- - KDE EDITION"

# ----------------------------
# ---- Copy System Files -----
# ----------------------------
# Copy all files to root directory
cp -avf "/ctx/system_files/kde"/. /
