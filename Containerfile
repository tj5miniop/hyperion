# --- Build Arguments ---
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG FEDORA_VERSION="${FEDORA_VERSION:-44}"
ARG ARCH="${ARCH:-x86_64}"

ARG BASE_IMAGE="${BASE_IMAGE:-ghcr.io/ublue-os/${BASE_IMAGE_NAME}-main:${FEDORA_VERSION}}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOUR:-ogc}"
# For the exact kernel version, use the kernel-version-checker script included in the image
ARG KERNEL_VERSION="${KERNEL_VERSION:-7.2.0-ogc6.1.fc${FEDORA_VERSION}.${ARCH}}"
ARG NVIDIA_FLAVOR="${NVIDIA_FLAVOUR:-nvidia-open}"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# --- Grab AKMODS ---
FROM ghcr.io/ublue-os/akmods:${KERNEL_FLAVOR}-${FEDORA_VERSION}-${KERNEL_VERSION} AS akmods
FROM ghcr.io/ublue-os/akmods-extra:${KERNEL_FLAVOR}-${FEDORA_VERSION}-${KERNEL_VERSION} AS akmods-extra
FROM ghcr.io/ublue-os/akmods-${NVIDIA_FLAVOR}:${KERNEL_FLAVOR}-${FEDORA_VERSION}-${KERNEL_VERSION} AS akmods-nvidia


# -- Base Image - code adapted from Bazzite ---
FROM ghcr.io/ublue-os/${BASE_IMAGE_NAME}-main:${FEDORA_VERSION} AS hyperion

# --- Intro Text ---





# Make OPT immutable to allow for Zen browser and extra packages to work
RUN echo "--- make OPT immutable temporarily ---" && rm /opt && mkdir /opt

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    --mount=type=bind,from=akmods,src=/rpms/common,dst=/tmp/rpms/common \
    --mount=type=bind,from=akmods,src=/rpms/kmods,dst=/tmp/rpms/kmods \
    --mount=type=bind,from=akmods-extra,src=/rpms/extra,dst=/tmp/rpms/extra \
    --mount=type=bind,from=akmods-extra,src=/rpms/kmods,dst=/tmp/rpms/kmods-extra \
    --mount=type=bind,from=akmods-nvidia,src=/rpms,dst=/tmp/rpms/nvidia \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    /ctx/akmods.sh && \
    /ctx/nvidia.sh && \
    /ctx/os-release.sh && \
    cp -r /ctx/system_files/usr/share/wallpapers/wallpaper.png /usr/share/wallpapers/ && \
    /ctx/initramfs.sh && \
    /ctx/cleanup.sh && \
    echo "--- Build Complete ---"


# Logic to make OPT back to be mutable in the image
RUN echo "-- Reverting OPT changes ---"
RUN set -euo pipefail && \
    if [ -d /opt ] && [ -d /var/opt ]; then \
        # Merge /opt into /var/opt
        cp -a /opt/. /var/opt/; \
        # Remove the old /opt directory
        rm -rf /opt; \
    elif [ -d /opt ] && [ ! -e /var/opt ]; then \
        # If /var/opt doesn't exist yet, simply move /opt there\
        mv /opt /var/opt; \
    fi && \
    # Create the symbolic link pointing /opt to /var/opt
    ln -s /var/opt /opt

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
