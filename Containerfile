# ==============================================================================
# GLOBAL BUILD ARGUMENTS
# ==============================================================================
ARG FEDORA_VERSION="${FEDORA_VERSION:-44}"
ARG ARCH="${ARCH:-x86_64}"
ARG BASE_IMAGE_KDE_NV="${BASE_IMAGE_KDE_NV:-ghcr.io/ublue-os/bazzite-nvidia-open:latest}"
ARG BASE_IMAGE_KDE="${BASE_IMAGE_KDE:-ghcr.io/ublue-os/bazzite:latest"
ARG BASE_IMAGE_UTAH="${BASE_IMAGE_UTAH:-ghcr.io/projectbluefin/utah-nvidia-gaming:testing}"

# ==============================================================================
# CONTEXT STAGE (Must be declared before any stage uses `from=ctx`)
# ==============================================================================
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files


# ==============================================================================
# FEDORA: hyperion (KDE Desktop - NVIDIA)
# ==============================================================================
FROM ${BASE_IMAGE_KDE_NV} AS hyperion

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/bazzite-fixups.sh && \
    /ctx/bazzite/build.sh && \
    /ctx/modules/desktop/kde.sh && \
    /ctx/modules/misc/os-release.sh && \
    /ctx/modules/misc/cleanup.sh && \
    echo "--- Build Complete: hyperion ---"

RUN bootc container lint


# ==============================================================================
# FEDORA: hyperion-utah (Utah-Nvidia Gaming)
# ==============================================================================
FROM ${BASE_IMAGE_UTAH} AS hyperion-utah

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/hummingbird/build.sh && \
    /ctx/modules/misc/os-release.sh && \
    /ctx/modules/misc/cleanup.sh && \
    echo "--- Build Complete: hyperion-utah ---"

RUN bootc container lint


# ==============================================================================
# FEDORA: hyperion-gnome (BAZZITE, GNOME Desktop - No NVIDIA)
# ==============================================================================
FROM ${BASE_IMAGE_GNOME} AS hyperion-gnome

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/bazzite-fixups.sh && \
    /ctx/bazzite/build.sh && \
    /ctx/modules/misc/os-release.sh && \
    /ctx/modules/misc/cleanup.sh && \
    echo "--- Build Complete: hyperion-gnome ---"

RUN bootc container lint
