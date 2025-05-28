#!/usr/bin/env bash
set -euo pipefail

#
# Usage:
#   source ./install.sh       # To load the install_nvm function into your shell
#   install_nvm               # To run the installation function explicitly
#
# Or run the script directly to install NVM and latest LTS Node.js:
#   ./install.sh
#

# Load helpers from relative path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/core/_logging.sh
source "$SCRIPT_DIR/../core/_logging.sh"

# shellcheck source=scripts/core/_checks.sh
source "$SCRIPT_DIR/../core/_checks.sh"

#!/usr/bin/env bash
set -euo pipefail

#
# Usage:
#   source ./install.sh       # To load the install_nvm function into your shell
#   install_nvm               # To run the installation function explicitly
#
# Or run the script directly to install NVM and latest LTS Node.js:
#   ./install.sh
#

# Load helpers from relative path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/core/_logging.sh
source "$SCRIPT_DIR/../core/_logging.sh"

# shellcheck source=scripts/core/_checks.sh
source "$SCRIPT_DIR/../core/_checks.sh"

install_nvm() {
  # Check if nvm is already installed
  if command -v nvm &> /dev/null; then
    log_success "NVM already installed."
    return 0
  fi

  # Ensure curl is available
  if ! require_command curl; then
    log_error "curl is required to install NVM. Please install curl first."
    return 1
  fi

  local NVM_DIR="$HOME/.nvm"

  log_info "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  # Load nvm immediately for the current shell session
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
  else
    log_error "NVM installation script did not produce expected files."
    return 1
  fi

  # Install latest LTS Node.js and set as default
  nvm install --lts
  nvm use --lts
  nvm alias default 'lts/*'

  log_success "NVM and Node.js installed: $(node -v)"
}

# Detect if script is run directly (not sourced)
# Reference: https://stackoverflow.com/a/28776166
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nvm
fi


# Detect if script is run directly (not sourced)
# Reference: https://stackoverflow.com/a/28776166
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nvm
fi
