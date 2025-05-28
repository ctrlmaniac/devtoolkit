#!/usr/bin/env zsh
#
# System and environment checks
#
# Usage:
#   require_root
#     Checks if running as root or if sudo is available.
#     Returns 0 if OK, 1 if not.
#
#   require_command <command>
#     Checks if the specified command is available.
#     Returns 0 if OK, 1 if not.
#
#   ensure_command_or_install <command> <package_manager> <install_command...>
#     Checks if <command> is available.
#     If not, checks if <package_manager> is installed.
#     Then tries to install <command> by running the install command with sudo.
#     Exits on failure.
#
# Note: This script sources logging helpers from _logging.zsh.
#

# Load logging helpers
source "$(dirname "${(%):-%N}")/_logging.zsh"

# Check if running as root or with sudo
require_root() {
  if [[ $EUID -ne 0 ]]; then
    if ! command -v sudo &> /dev/null; then
      log_error "sudo not found and you are not root. Aborting."
      return 1
    fi
  fi
  return 0
}

# Check if a command exists
require_command() {
  if ! command -v "$1" &> /dev/null; then
    log_error "Required command '$1' not found. Please install it."
    return 1
  fi
  return 0
}

# Ensure command exists, or install it using a specified package manager and install command
#
# Arguments:
#   $1 - command to check/install
#   $2 - package manager command (e.g. apt, brew, pacman)
#   $3..$n - install command and arguments (e.g. install -y jq)
#
# Example:
#   ensure_command_or_install jq apt install -y jq
#
ensure_command_or_install() {
  local cmd=$1
  local pkg_mgr=$2
  shift 2
  local install_cmd=("$@")

  if ! command -v "$cmd" &> /dev/null; then
    log_warn "'$cmd' not found. Attempting to install using '$pkg_mgr'..."

    if ! command -v "$pkg_mgr" &> /dev/null; then
      log_error "Package manager '$pkg_mgr' not found. Cannot install '$cmd'."
      return 1
    fi

    if ! sudo "$pkg_mgr" "${install_cmd[@]}"; then
      log_error "Failed to install '$cmd' using '$pkg_mgr'."
      return 1
    fi

    if ! command -v "$cmd" &> /dev/null; then
      log_error "'$cmd' installation did not succeed after running '$pkg_mgr ${install_cmd[*]}'."
      return 1
    fi

    log_success "'$cmd' installed successfully."
  else
    log_success "'$cmd' already installed."
  fi
}
