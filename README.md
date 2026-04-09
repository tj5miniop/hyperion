# -------- MAJOR REWRITE IN PROGRESS ---------
### I have been having issues with this container for ages now, so I have decided to rewrite it fully to hopefully get it back up and running
## THEREFORE - THIS IS NOT PRODUCTION READY

# 🌌 Hyperion

The Atomic Arch Linux Powerhouse for Gaming

Hyperion is a "hobby-experiment" of mine - built on Arch Linux using bootc. It is designed to provide a "Steam Deck-like" experience for desktops which is optimized for gaming and ready to go out of the gate.

# ** NOTE
## Features

- **Atomic Updates**: Powered by bootc. Updates are applied as single image transactions—no more partial upgrades or broken dependencies. These will function similarly to images such as Bazzite. 

- **KDE Plasma**: A modern desktop environment used by a variety of distributions - KDE aims to create a familiar desktop experience. **For you WM lovers out there, a Hyprland base will be created once this image is in a stable state.**

### Immutability and read-only filesystem

The core system is read-only, ensuring stability. The system itself uses [bootc](https://github.com/containers/bootc), the same technology which powers Fedora Atomic Desktops and its derivatives, such as [Bazzite](https://bazzite.gg).

## Kernel Integration

**Hyperion uses a new [custom compiled kernel](https://github.com/tj5miniop/linux-tkg) based on the [Linux TKG kernel](https://github.com/FroggingFamily/linux-tkg), integrating the best optimizations from the Linux Gaming community (Bazzite, Nobara, CachyOS and the newly established Open Gaming Con):**

- **Multi-Source Patches**: Includes cherry-picked performance enhancements from CachyOS, Nobara, Bazzite, and the OGC Kernel.
- **Low Latency**: The system is configured to use scx_lavd. LAVD is the scheduler developer by Valve for steam hardware and shows a reduction in latency and a potential performance increase in some scenarios.

- **Hardware Support**: Enhanced drivers for handhelds, controllers, and modern GPUs (AMD/Intel).

**NOTE**: NVIDIA support is being worked on. DKMS modules are still to be added

## Gaming & Software Integration

### Steam & Heroic Integration

Pre-installed and pre-configured with essential dependencies (MangoHud, Gamescope).

### Flatpak

Installed and ready to use, allowing you to easily install all your apps.

Hyperion is built automatically via GitHub Actions. Every commit to the repo triggers a new OCI image build. Images are cryptographically signed with Cosign to ensure integrity.

Available via GitHub Container Registry (GHCR).

## Special thanks to:

- The Arch Linux Team for the incredible foundation.
- The Universal Blue (uBlue) Project for the architectural inspiration.
- CachyOS, Nobara, & Bazzite for their pioneering work in Linux gaming optimizations.
- Bootcrew for the Arch Linux bootc container.