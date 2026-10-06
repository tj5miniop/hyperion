#!/bin/bash
# Colors for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Script path variables (for use within the container)
export BASE_DIR="/ctx"
export ASUS_SCRIPT="${BASE_DIR}/modules/hardware/asus.sh"
export GNOME_SCRIPT="${BASE_DIR}/modules/desktop/gnome.sh"
export KDE_SCRIPT="${BASE_DIR}/modules/desktop/kde.sh"
export LABWC_SCRIPT="${BASE_DIR}/modules/desktop/labwc.sh"
# Add more as needed
