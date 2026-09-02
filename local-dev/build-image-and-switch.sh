#!/bin/bash
SYSTEM_IMAGE_LOCAL=localhost/hyperion-local:latest
GHCR=ghcr.io/tj5miniop/hyperion:latest

# Use Podman to Build image
sudo podman build --pull=newer -t $SYSTEM_IMAGE_LOCAL ../

# After building the image (using SUDO) - move over to the new local development image
sudo bootc switch --transport containers-storage $SYSTEM_IMAGE_LOCAL


