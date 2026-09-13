# Hyperion HTPC edition

# Copy system files
cp -avf "/ctx/system_files/htpc"/. /

# Install certain HTPC-Related Packages
dnf -y install \
    gamescope-session-steam \
    inputplumber \
    steamos-manager \
    steam-notif-daemon \
    gamescope-session \
