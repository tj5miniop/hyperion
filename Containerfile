# --- Build Arguments ---
# Fedora Versions
ARG FEDORA_VERSION="${FEDORA_VERSION:-45}"
ARG ARCH="${ARCH:-x86_64}"

# Base images (Using official quay.io/fedora repositories)
ARG BASE_IMAGE_KDE="${BASE_IMAGE_KDE:-quay.io/fedora/fedora-kinoite:${FEDORA_VERSION}}"
ARG BASE_IMAGE_WM="${BASE_IMAGE_WM:-quay.io/fedora/fedora-bootc:${FEDORA_VERSION}}"
ARG BASE_IMAGE_GNOME="${BASE_IMAGE_GNOME:-quay.io/fedora/fedora-silverblue:${FEDORA_VERSION}}"

# Kernels
ARG KERNEL_FLAVOR="${KERNEL_FLAVOUR:-ogc}"
ARG KERNEL_RELEASE="7.2.8-ogc2.1"
ARG KERNEL_VERSION="${FEDORA_VERSION}-${KERNEL_RELEASE}.fc${FEDORA_VERSION}.${ARCH}"
ARG NVIDIA_FLAVOR="${NVIDIA_FLAVOUR:-nvidia-open}"



# --- Context Stage ---
# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# --- Grab AKMODS ---
FROM ghcr.io/ublue-os/akmods:${KERNEL_FLAVOR}-${KERNEL_VERSION} AS akmods
FROM ghcr.io/ublue-os/akmods-extra:${KERNEL_FLAVOR}-${KERNEL_VERSION} AS akmods-extra
FROM ghcr.io/ublue-os/akmods-${NVIDIA_FLAVOR}:${KERNEL_FLAVOR}-${KERNEL_VERSION} AS akmods-nvidia

# ---
# hyperion - base image, NO NVIDIA drivers
# ---
FROM ${BASE_IMAGE_KDE} AS hyperion

# Make OPT immutable to allow for Zen browser and extra packages to work
RUN echo "--- make OPT immutable ---" && rm -rf /opt && mkdir /opt

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    --mount=type=bind,from=akmods,src=/rpms/common,dst=/tmp/rpms/common \
    --mount=type=bind,from=akmods,src=/rpms/kmods,dst=/tmp/rpms/kmods \
    --mount=type=bind,from=akmods-extra,src=/rpms/extra,dst=/tmp/rpms/extra \
    --mount=type=bind,from=akmods-extra,src=/rpms/kmods,dst=/tmp/rpms/kmods-extra \
    /ctx/build.sh && \
    /ctx/kde.sh && \
    /ctx/akmods.sh && \
    /ctx/nvidia.sh && \
    /ctx/os-release.sh && \
    /ctx/initramfs.sh && \
    /ctx/cleanup.sh && \
    echo "--- Build Complete: hyperion ---"

# ---
# hyperion - minimal base image with LABWC, NO NVIDIA drivers
# ---
FROM ${BASE_IMAGE_WM} AS hyperion-labwc

# Make OPT immutable to allow for Zen browser and extra packages to work
RUN echo "--- make OPT immutable ---" && rm -rf /opt && mkdir /opt

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    --mount=type=bind,from=akmods,src=/rpms/common,dst=/tmp/rpms/common \
    --mount=type=bind,from=akmods,src=/rpms/kmods,dst=/tmp/rpms/kmods \
    --mount=type=bind,from=akmods-extra,src=/rpms/extra,dst=/tmp/rpms/extra \
    --mount=type=bind,from=akmods-extra,src=/rpms/kmods,dst=/tmp/rpms/kmods-extra \
    /ctx/build.sh && \
    /ctx/labwc.sh && \
    /ctx/akmods.sh && \
    /ctx/nvidia.sh && \
    /ctx/os-release.sh && \
    /ctx/initramfs.sh && \
    /ctx/cleanup.sh && \
    echo "--- Build Complete: hyperion-labwc ---"

# ---
# hyperion - base image with The GNOME Desktop environment - NO NVIDIA drivers
# ---
FROM ${BASE_IMAGE_GNOME} AS hyperion-gnome

# Make OPT immutable to allow for Zen browser and extra packages to work
RUN echo "--- make OPT immutable ---" && rm -rf /opt && mkdir /opt

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    --mount=type=bind,from=akmods,src=/rpms/common,dst=/tmp/rpms/common \
    --mount=type=bind,from=akmods,src=/rpms/kmods,dst=/tmp/rpms/kmods \
    --mount=type=bind,from=akmods-extra,src=/rpms/extra,dst=/tmp/rpms/extra \
    --mount=type=bind,from=akmods-extra,src=/rpms/kmods,dst=/tmp/rpms/kmods-extra \
    /ctx/build.sh && \
    /ctx/gnome.sh && \
    /ctx/asus.sh && \
    /ctx/akmods.sh && \
    /ctx/os-release.sh && \
    /ctx/initramfs.sh && \
    /ctx/cleanup.sh && \
    echo "--- Build Complete: hyperion-gnome ---"

### LINTING
RUN bootc container lint
