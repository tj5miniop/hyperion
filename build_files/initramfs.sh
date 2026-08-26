#!/usr/bin/bash
set -eoux pipefail

echo "::group::Executing build-initramfs"
trap 'echo "::endgroup::"' EXIT

KERNEL="$(dnf5 repoquery --installed --queryformat='%{evr}.%{arch}' kernel)"

/usr/bin/dracut --no-hostonly --kver "$KERNEL" --reproducible --zstd -v --add ostree --add fido2 -f "/usr/lib/modules/$KERNEL/initramfs.img"

chmod 0600 "/usr/lib/modules/$KERNEL/initramfs.img"