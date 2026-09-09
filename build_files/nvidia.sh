#!/usr/bin/bash
set -ouex pipefail

# Adapted Nvidia-Install
IMAGE_NAME="SKIP_PACKAGE_INSTALL" AKMODNV_PATH="/tmp/rpms/nvidia" MULTILIB=1 /tmp/rpms/nvidia/ublue-os/nvidia-install.sh

# Install NVIDIA specific files
# Copy all files to root directory
cp -avf "/ctx/system_files/shared/nvidia"/. /