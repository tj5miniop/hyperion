#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# Remove some GNOME apps, replace firefox with flatpak for more stability 
rpm-ostree install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
rpm-ostree override remove firefox
rpm-ostree install firefox zsh fzf
flatpak install flathub org.mozilla.firefox
flatpak install org.mozilla.Thunderbird
flatpak install flathub io.github.dvlv.boxbuddyrs
flatpak install flathub dev.vencord.Vesktop

#Install Icon Theme
rpm-ostree install papirus-icon-theme breeze-cursor-theme

# curl --output-dir "/etc/yum.repos.d/" --remote-name 
#### Example for enabling a System Unit File
#Make sure podman is enabled, allowing distrobox to function
systemctl enable podman.socket
