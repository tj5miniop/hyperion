# --- Build Arguments ---
# Fedora Versions
ARG FEDORA_VERSION="${FEDORA_VERSION:-45}"
ARG ARCH="${ARCH:-x86_64}"

# Base images (Using official fedora-kinoite/fedora-silverblue/fedora-bootc repositories)
ARG BASE_IMAGE_KDE="${BASE_IMAGE_KDE:-quay.io/fedora/fedora-kinoite:${FEDORA_VERSION}}"
ARG BASE_IMAGE_WM="${BASE_IMAGE_WM:-quay.io/fedora/fedora-bootc:${FEDORA_VERSION}}"
ARG BASE_IMAGE_GNOME="${BASE_IMAGE_GNOME:-quay.io/fedora/fedora-silverblue:${FEDORA_VERSION}}"

# Kernels
ARG KERNEL_FLAVOR="${KERNEL_FLAVOUR:-ogc}"
ARG KERNEL_RELEASE="7.2.8-ogc2.1"
ARG KERNEL_VERSION="${FEDORA_VERSION}-${KERNEL_RELEASE}.fc${FEDORA_VERSION}.${ARCH}"
ARG NVIDIA_FLAVOR="${NVIDIA_FLAVOUR:-nvidia-open}"



# --- Context Stage ---
FROM scratch AS ctx
# We copy the contents of build_files into /ctx/ so that build.sh is at /ctx/build.sh
# and lib/utils.sh is at /ctx/lib/utils.sh
COPY build_files /ctx/
COPY system_files /ctx/system_files

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
    --mount=type-bind,from=akmods-nvidia,src=/rpms,dst=/tmp/rpms/nvidia \
    /ctx/build.sh && \
    /ctx/modules/desktop/kde.sh && \
    /ctx/akmods.sh && \
    /ctx/nvidia.sh && \
    /ctx/os-release.sh && \
    /ctx/initramfs.sh && \
    /ctx/cleanup.sh && \
    echo "--- Build Complete ---"

# ---
# hyperion - minimal base image with LABWC, WITH NVIDIA drivers
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
    --mount=type=bind,from=akmods-nvidia,src=/rpms,dst=/tmp/rpms/nvidia \
    /ctx/build.sh && \
    /ctx/modules/desktop/labwc.sh && \
    /ctx/akmods.sh && \
    /ctx/nvidia.sh && \
    /ctx/os-release.sh && \
    /ctx/initramfs.sh && \
    /ctx/cleanup.sh && \
    echo "--- Build Complete ---"

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
    /ctx/modules/desktop/gnome.sh && \
    /ctx/modules/hardware/asus.sh && \
    /ctx/akmods.sh && \
    /ctx/os-release.sh && \
    /ctx/initramfs.sh && \
    /ctx/cleanup.sh && \
    echo "--- Build Complete ---"

### LINTING
RUN bootc container lint
