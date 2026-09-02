#!/bin/bash
SYSTEM_IMAGE_LOCAL=localhost/hyperion-local:latest
GHCR=ghcr.io/tj5miniop/hyperion:latest

# Use Podman to Build image
echo "--- Building Image ---"
sudo podman build --pull=newer -t $SYSTEM_IMAGE_LOCAL ../

# After building the image (using SUDO) - move over to the new local development image
echo "--- Automatically Switching to new image ---"
sudo bootc switch --transport containers-storage $SYSTEM_IMAGE_LOCAL

echo "---"
echo "---" 

echo "Please reboot when ready (no automatic reboots so you can save your work :) ."

