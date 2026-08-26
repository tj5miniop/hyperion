#!/bin/bash
# CREDIT TO BAZZITE (https://github.com/ublue-os/bazzite/blob/main/build_files/install-kernel-akmods) For the original code
# Ensure that if any errors occur, the script will stop
#!/usr/bin/bash

set -ouex pipefail

# create a shims to bypass kernel install triggering dracut/rpm-ostree
# seems to be minimal impact, but allows progress on build
pushd /usr/lib/kernel/install.d
mv 05-rpmostree.install 05-rpmostree.install.bak
mv 50-dracut.install 50-dracut.install.bak
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd

# Remove Existing Kernel
for pkg in kernel kernel{-core,-modules,-modules-core,-modules-extra,-tools-libs,-tools}; do
    rpm --erase "${pkg}" --nodeps
done

# cleanup leftovers that are not covered by kernel-* packages for some reason
rm -rf /usr/lib/modules

dnf5 -y install \
    /tmp/kernel-rpms/kernel-[0-9]*.rpm \
    /tmp/kernel-rpms/kernel-core-*.rpm \
    /tmp/kernel-rpms/kernel-modules-*.rpm \
    /tmp/kernel-rpms/kernel-devel-*.rpm

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules

# Changes here; Removed some kmods as not used by me
/ctx/install-kmods.sh \
    /tmp/rpms/{common,kmods}/*kvmfr*.rpm \
    /tmp/rpms/{common,kmods}/*openrazer*.rpm \
    /tmp/rpms/{common,kmods}/*v4l2loopback*.rpm \
    /tmp/rpms/{common,kmods}/*xone*.rpm

/ctx/install-kmods.sh \
    /tmp/rpms/{extra,kmods-extra}/*zenergy*.rpm \
    /tmp/rpms/{extra,kmods-extra}/*kvmfr*.rpm \
    /tmp/rpms/{extra,kmods-extra}/*hid-fanatecff*.rpm \
    /tmp/rpms/{extra,kmods-extra}/*ryzen_smu*.rpm \

pushd /usr/lib/kernel/install.d
mv -f 05-rpmostree.install.bak 05-rpmostree.install
mv -f 50-dracut.install.bak 50-dracut.install
popd