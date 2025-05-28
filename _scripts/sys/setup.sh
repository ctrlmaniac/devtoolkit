#!/usr/bin/env bash
set -euo pipefail

#
# Usage:
#   ./setup.sh
#
# This script performs system setup:
# - Ensures snap, jq, yq are installed (installing via apt or snap)
# - Installs recommended Ubuntu packages from recommendations/sys-ubuntu.yml
# - Optionally offers to switch the default shell to Zsh
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/core/_logging.sh
source "$SCRIPT_DIR/../core/_logging.sh"

# shellcheck source=scripts/core/_checks.sh
source "$SCRIPT_DIR/../core/_checks.sh"

install_snap_if_needed() {
  if ! command -v snap &> /dev/null; then
    log_warn "'snap' is not installed. Installing 'snapd'..."
    sudo apt update -y && sudo apt install -y snapd
    if ! command -v snap &> /dev/null; then
      log_error "Failed to install 'snap'. Aborting."
      exit 1
    fi
    log_success "'snap' installed successfully."
  else
    log_success "'snap' already installed."
  fi
}

install_jq() {
  ensure_command_or_install "jq" "apt install -y jq" "Failed to install 'jq'. Aborting."
}

install_yq() {
  if ! command -v yq &> /dev/null; then
    log_warn "'yq' not found. Installing with snap..."
    if ! sudo snap install yq; then
      log_error "Failed to install 'yq'. Aborting."
      exit 1
    fi
    if ! command -v yq &> /dev/null; then
      log_error "'yq' installation did not succeed. Aborting."
      exit 1
    fi
    log_success "'yq' installed successfully."
  else
    log_success "'yq' already installed."
  fi
}

install_base_packages() {
  local config_file="$SCRIPT_DIR/../../recommendations/sys-ubuntu.yml"

  if [ ! -f "$config_file" ]; then
    log_error "Configuration file not found at: $config_file"
    exit 1
  fi

  log_info "Installing base packages from recommendations..."
  mapfile -t base_packages < <(yq -r '.ubuntu.packages[]' "$config_file")

  sudo apt update -y
  sudo apt install -y "${base_packages[@]}"
  log_success "Ubuntu system tools installed."
}

offer_zsh_switch() {
  read -r -p "[devtoolkit] 🐚 Would you like to switch to Zsh? (y/n): " switch_shell
  if [[ "$switch_shell" =~ ^[Yy]$ ]]; then
    log_info "Installing and setting up Zsh..."
    sudo apt install -y zsh
    chsh -s "$(which zsh)"
    log_success "Default shell changed to Zsh. Please restart your terminal."
  fi
}

main() {
  log_info "Starting system setup..."
  install_snap_if_needed
  install_jq
  install_yq
  install_base_packages
  offer_zsh_switch
}

main "$@"
