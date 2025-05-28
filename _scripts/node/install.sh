#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/node/nvm/install.sh
# shellcheck source=scripts/node/nvm/install.sh
source "$(dirname "$0")/nvm/install.sh"

# shellcheck source=scripts/node/nvm/install.sh
source "$(dirname "$0")/pm/install.sh"

install_nvm
install_pm "${1:-pnpm}"
