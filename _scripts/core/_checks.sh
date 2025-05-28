#!/usr/bin/env bash
#
# System and environment checks
#
# Usage:
#   require_root
#     Checks if the script is run as root or if sudo is available.
#     Exits the script if neither condition is met.
#
#   check_command <command>
#     Checks if the specified command exists in PATH.
#     Returns 0 if the command exists, 1 otherwise.
#
#   ensure_command_or_install <command> <package_manager> <install_command>
#     Checks if the <command> exists, if not attempts to install it using
#     the specified <package_manager> and the <install_command>.
#     Exits if the package manager or the installation fails.
#
# Example:
#   require_root
#   check_command "curl"
#   ensure_command_or_install "jq" "apt" "apt install -y jq"
#

# Source logging functions
# shellcheck source=scripts/core/_logging.sh
source "$(dirname "${BASH_SOURCE[0]}")/_logging.sh"

# check_command <command>
# Checks whether the given command is available in the system PATH.
# Returns 0 if the command is found; returns 1 and logs an error if not.
check_command() {
  if ! command -v "$1" &> /dev/null; then
    log_error "Command '$1' not found."
    return 1
  fi
  return 0
}

# require_root
# Checks if the current user is root (EUID=0) or if 'sudo' is available.
# Exits the script with status 1 if neither condition is met.
require_root() {
  if [[ $EUID -ne 0 ]]; then
    if ! command -v sudo &> /dev/null; then
      log_error "This script requires root privileges or sudo but neither found."
      exit 1
    fi
  fi
}

# ensure_command_or_install <command> <package_manager> <install_command>
# Checks if the <command> is available.
# If not, verifies that the <package_manager> exists and uses it to run <install_command>.
# Logs progress and exits on failure.
ensure_command_or_install() {
  local cmd=$1
  local pkg_mgr=$2
  shift 2
  local install_cmd=("$@")  # Array of install command + args

  if ! command -v "$cmd" &> /dev/null; then
    log_warn "'$cmd' not found. Attempting to install using '$pkg_mgr'..."

    if ! command -v "$pkg_mgr" &> /dev/null; then
      log_error "Package manager '$pkg_mgr' not found. Cannot install '$cmd'."
      exit 1
    fi

    if ! sudo "${install_cmd[@]}"; then
      log_error "Failed to install '$cmd' using '$pkg_mgr'."
      exit 1
    fi

    if ! command -v "$cmd" &> /dev/null; then
      log_error "'$cmd' installation did not succeed after running '${install_cmd[*]}'."
      exit 1
    fi

    log_success "'$cmd' installed successfully."
  else
    log_success "'$cmd' already installed."
  fi
}

