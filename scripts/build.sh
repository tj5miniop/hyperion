#!/usr/bin/env bash

echo "Preparing image for Bootc"

set -oux pipefail

# move /var directories to /usr/lib/sysimage for bootc usroverlay compatibility
grep "= */var" /etc/pacman.conf | sed "/= *\/var/s/.*=// ; s/ //" | \
    xargs -n1 sh -c \
        'mkdir -p "/usr/lib/sysimage/$(dirname $(echo $1 | sed "s@/var/@@"))" && \
         mv -v "$1" "/usr/lib/sysimage/$(echo "$1" | sed "s@/var/@@")"' '' >/dev/null

set -e

# update pacman.conf accordingly
sed -i \
    -e "/= *\/var/ s/^#//" \
    -e "s@= */var@= /usr/lib/sysimage@g" \
    -e "/DownloadUser/d" \
    /etc/pacman.conf

# Edit /etc/sudoers - allowing whell group members to run root commands via sudo
echo "%wheel ALL=(ALL:ALL)" | tee -a /etc/sudoers

# init keys
pacman-key --init
pacman-key --populate archlinux

# add bootc repo - Credit to https://github.com/hecknt/arch-bootc-pkgs
pacman-key --recv-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB
echo -e '\n[bootc]\nSigLevel = Required\nServer=https://github.com/hecknt/arch-bootc-pkgs/releases/download/$repo' >> /etc/pacman.conf

# perform system update
pacman -Syu --noconfirm >/dev/null

# Install core packages
pacman -S --noconfirm systemd base base-devel uupd bootc cpio dracut efibootmgr linux-firmware ostree shadow shim skopeo udev bash gcc git nano wget btrfs-progs dosfstools e2fsprogs erofs-utils xfsprogs

# Install GRUB - just in case
pacman -S --noconfirm grub

# Add hardware support
echo "--- AMD ---"
pacman -S --noconfirm amd-ucode vulkan-radeon libva-mesa-driver
echo "--- INTEL ---"
pacman -S --noconfirm intel-ucode vulkan-intel libva-intel-driver

# SCX Sched config
echo "SCX Configuration"
echo "SCX_SCHEDULER=scx_lavd" | tee -a /etc/default/scx

# Kernel installation + dkms modules
pacman -Sy --noconfirm dra # Install DRA 
mkdir -p /tmp/hyperion/kernel
cd /tmp/hyperion/kernel
# Install custom kernel
dra download tj5miniop/linux-tkg --select "linux*"
dra download tj5miniop/linux-tkg --select "*header*"
pacman -U --noconfirm *.pkg*


# KDE plasma
pacman -Sy --noconfirm plasma-login-manager plasma-desktop plasma-nm plasma-pa kscreen powerdevil power-profiles-daemon networkmanager

# systemd
systemctl enable plasmalogin
systemctl enable NetworkManager

# Dracut Initramfs configuration
KERNEL_VERSION="$(basename "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "\.img$" | tail -n 1)")"
DRACUT_NO_XATTR=1 dracut --force --no-hostonly --reproducible --zstd --verbose --kver "$KERNEL_VERSION" "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"

# XBOX Controller support - put this after initramfs 
pacman -Sy --noconfirm xone-dkms-git xpadneo-dkms
# NVIDIA DRIVERS can be added here? 

# Steam Deck Like configuration 
pacman -Sy --noconfirm gamescope steamdeck-kde-presets

# Flatpak 
pacman -Sy --noconfirm flatpak

# install fish shell & utilities
pacman -Sy fish micro nano vi 
echo "SHELL=/bin/fish" >> /etc/default/useradd


# FINAL initramfs
#!/usr/bin/env bash
# CREDIT GOES TO BOOTCREW
set -xeuo pipefail
mkdir -p /usr/lib/dracut/dracut.conf.d/
printf "systemdsystemconfdir=/etc/systemd/system\nsystemdsystemunitdir=/usr/lib/systemd/system\n" | tee /usr/lib/dracut/dracut.conf.d/30-bootcrew-fix-bootc-module.conf
printf 'reproducible=yes\nhostonly=no\ncompress=zstd\nadd_dracutmodules+=" bootc "' | tee "/usr/lib/dracut/dracut.conf.d/30-bootcrew-bootc-container-build.conf"
dracut --force "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "*.img" | tail -n 1)/initramfs.img"


# FS tweaks
# Change dir to root - can this fix root unmounting issue?
cd / 

# Cleanup
echo "-- running cleanup --"
rm -rf /tmp/* /run/*
rm -rf /{boot,home,root,srv,mnt,var,usr/local,opt}
rm -rf /usr/lib/sysimage/{log,cache/pacman/pkg}
rm -rf /{build,packages}
# (re)create essential system directories
mkdir -p /sysroot /boot /usr/lib/ostree /var
# create symlinks aligning with BOOTC
ln -sT sysroot/ostree /ostree
ln -sT var/roothome /root
ln -sT var/srv /srv
ln -sT var/mnt /mnt
ln -sT var/opt /opt
ln -sT var/home /home
ln -sT var/usrlocal /usr/local
