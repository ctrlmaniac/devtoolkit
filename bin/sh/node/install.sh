#!/usr/bin/env bash
# node/install.sh
#
# USAGE:
#   source node/install.sh
#
# DESCRIPTION:
#   Orchestrates Node.js environment setup by running the NVM installer and
#   package manager installer scripts in order.
#
#   ⚠️ IMPORTANT: This script must be sourced to apply environment changes and aliases
#   correctly in the current shell session.
#
#   Running it directly will install things but will not update your current shell environment.

set -euo pipefail

# Check if script is sourced or run directly
# This check is primarily for Bash. If BASH_SOURCE[0] is set (we are likely in Bash)
# and it's equal to $0, then the script is being executed directly.
# The use of ${BASH_SOURCE[0]:-} inside the -n check prevents "unbound variable" error if BASH_SOURCE array is empty or BASH_SOURCE[0] is unset (e.g. when sourced in Zsh)
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "❌ This script must be sourced to work correctly."
  echo "➡️ Please run:"
  echo "    source ${BASH_SOURCE[0]}" # BASH_SOURCE[0] is confirmed to be set here
  exit 1
fi

echo "🚀 Starting Node.js environment setup..."

# Source NVM installer script
if [ -f "$(dirname "${BASH_SOURCE[0]}")/nvm-install.sh" ]; then
  echo -e "\n📥 Running NVM installer..."
  source "$(dirname "${BASH_SOURCE[0]}")/nvm-install.sh"
else
  echo "⚠️ nvm-install.sh not found. Skipping NVM installation."
fi

# Source PM installer script
if [ -f "$(dirname "${BASH_SOURCE[0]}")/pm-install.sh" ]; then
  echo -e "\n📥 Running Package Manager installer..."
  source "$(dirname "${BASH_SOURCE[0]}")/pm-install.sh"
else
  echo "⚠️ pm-install.sh not found. Skipping Package Manager installation."
fi

echo -e "\n✅ Node.js environment setup complete."
echo "💡 Remember to add any alias commands you agreed to permanently in your shell profile (e.g. ~/.bashrc or ~/.zshrc) if you want them to persist between sessions."
