#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# Install LATEST Cosmic
rpm-ostree install curl 
curl --output-dir "/etc/yum.repos.d/" --remote-name https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-41/ryanabx-cosmic-epoch-fedora-41.repo
rpm-ostree install flatpak distrobox podman
rpm-ostree install sddm cosmic-desktop
# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket
