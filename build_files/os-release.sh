#!/usr/bin/bash
set -eoux pipefail

# set os-release vars 
IMAGE_PRETTY_NAME="Hyperion"
BASE_IMAGE_NAME="hyperion"
IMAGE_NAME="hyperion"
FEDORA_VERSION="44"
VERSION_TAG=$FEDORA_VERSION
VERSION_PRETTY=$FEDORA_VERSION
IMAGE_LIKE="fedora"
HOME_URL="https://github.com/tj5miniop/hyperion"
DOCUMENTATION_URL="https://github.com/tj5miniop/hyperion"
SUPPORT_URL="https://github.com/tj5miniop/hyperion"
BUG_SUPPORT_URL="https://github.com/tj5miniop/hyperion/issues"
IMAGE_INFO="/usr/share/ublue-os/image-info.json"

# credit to BAZZITE again - adapted to my needs 

# Image Info File
cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-tag": "rolling-$FEDORA_VERSION",
  "fedora-version": "$FEDORA_VERSION",
  "version": "$VERSION_TAG",
  "version-pretty": "$VERSION_PRETTY"
}
EOF

# OS Release File
sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Hyperion\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"|" /usr/lib/os-release
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,}\"/" /usr/lib/os-release
sed -i "s/^ID=fedora/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"${IMAGE_LIKE}\"/" /usr/lib/os-release

# Rebrand system-release so that grub2-mkconfig uses "Bazzite" as the distributor
echo "$IMAGE_PRETTY_NAME release $FEDORA_VERSION (${BASE_IMAGE_NAME^})" > /etc/system-release

# Fix issues caused by ID no longer being fedora
sed -i "s/^EFIDIR=.*/EFIDIR=\"fedora\"/" /usr/sbin/grub2-switch-to-blscfg

if grep -q '^BUILD_ID=' /usr/lib/os-release; then
  sed -i "s/^BUILD_ID=.*/BUILD_ID=\"$VERSION_PRETTY\"/" /usr/lib/os-release
else
  echo "BUILD_ID=\"$VERSION_PRETTY\"" >> /usr/lib/os-release
fi

if grep -q '^BOOTLOADER_NAME=' /usr/lib/os-release; then
  sed -i "s/^BOOTLOADER_NAME=.*/BOOTLOADER_NAME=\"$IMAGE_PRETTY_NAME $VERSION_PRETTY\"/" /usr/lib/os-release
else
  echo "BOOTLOADER_NAME=\"$IMAGE_PRETTY_NAME $VERSION_PRETTY\"" >> /usr/lib/os-release
fi

# IMAGE_ID is used to decide whether to load a hibernation image
# use a unique id to prevent loading stale hibernation images
# INITRAMFS NEEDS TO BE GENERATED AFTER THIS SCRIPT HAS RUN
if grep -q '^IMAGE_ID=' /usr/lib/os-release; then
  sed -i "s/^IMAGE_ID=.*/IMAGE_ID=\"$IMAGE_NAME-$VERSION_TAG\"/" /usr/lib/os-release
else
  echo "IMAGE_ID=\"$IMAGE_NAME-$VERSION_TAG\"" >> /usr/lib/os-release
fi