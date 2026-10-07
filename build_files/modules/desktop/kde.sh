#
# Hyperion Desktop Edition (KDE) files - any app/setting not present in LABWC lives here
# Very Minimal at the MOMENT

#!/bin/bash

# Install base packages
echo "--- installing KDE base packages... --- - KDE EDITION"
dnf -y install ghostty kvantum
echo "--- installing KDE/GNOME apps -- - KDE EDITION"

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


# Install Plasma Widgets/Dependencies

# Audio (Cava etc) 
dnf5 -y install cava qt6-qtwebsockets-devel python-websockets

# ---------------------------
# ------- Theming -----------
# ---------------------------
# This section of the script does not directly set up the dotfiles but will install all dependencies
# Papirus Icons
dnf5 -y install papirus-icon-theme

# Install Layan theme for KDE
echo "--- Layan Theme - CREDIT VINCELLUICE ---"
DIR_Layan=/tmp/themes/
REPO_NAME=Layan-kde
mkdir -p $DIR_Layan && cd $DIR_Layan
git clone https://github.com/vinceliuice/"$REPO_NAME" && cd $REPO_NAME
bash ./install.sh

cd /tmp
# ----------------------------
# ---- Copy System Files -----
# ----------------------------
# Copy all files to root directory
cp -avf "/ctx/system_files/kde"/. /
