#!/usr/bin/env bash
# devtoolkit/libs/sys/_apt-install.sh
#
# Internal helper to safely install packages using apt-get
#
# USAGE
#   apt_install <package-name>
#
# DESCRIPTION
#   Checks if the package is already installed with dpkg.
#   If not installed, updates apt cache and installs the package.
#   Prints success or failure messages using logging utilities.
#
# DEPENDS ON
#   - sudo must be available and configured for the current user
#   - utils/log.sh    provides log_info, log_success, log_error

set -euo pipefail

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../env.sh
source "$SCRIPT_DIR/../../env.sh"

# shellcheck disable=SC1090
source "$UTIL_IO"

apt_install() {
  local pkg="$1"

  if dpkg -s "$pkg" >/dev/null 2>&1; then
    log_success "$pkg is already installed. Skipping."
    return 0
  fi

  log_info "Installing $pkg..."
  sudo apt-get update -y
  sudo apt-get install -y "$pkg"

  if dpkg -s "$pkg" >/dev/null 2>&1; then
    log_success "Successfully installed $pkg."
  else
    log_error "Failed to install $pkg."
    return 1
  fi
}
