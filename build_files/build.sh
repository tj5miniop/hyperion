#!/bin/bash
# Ensure that if any errors occur, the script will stop
set -ouex pipefail
systemctl enable podman.socket
