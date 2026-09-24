# Hyperion HTPC edition

# Copy system files - NOT NEEDED AS OF NOW AS IT USES THE ASUS FILES
#cp -avf "/ctx/system_files/htpc"/. /

# Install certain HTPC-Related Packages
dnf -y install \
    gamescope-session-steam \
    inputplumber \
    steamos-manager \
    steam-notif-daemon \
    gamescope-session \
    plasma-applet-tdp-control \
