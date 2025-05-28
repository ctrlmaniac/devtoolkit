#!/usr/bin/env zsh
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

setopt errexit nounset pipefail

# Check if script is sourced or run directly
# This check is primarily for Bash. If BASH_SOURCE[0] is set (we are likely in Bash)
# and it's equal to $0, then the script is being executed directly.
# The use of ${BASH_SOURCE[0]:-} inside the -n check prevents "unbound variable" error if BASH_SOURCE array is empty or BASH_SOURCE[0] is unset (e.g. when sourced in Zsh)
# For Zsh, if $0 (what was typed to run the script) is the same as the script's actual path/name, it's likely executed.
# A more robust Zsh check for "executed directly" is if ZSH_EVAL_CONTEXT does not indicate sourcing.
if [[ $0 == ${(%):-%x} || $0 == ${(%):-%N} ]]; then # Heuristic: if command matches script path or name
  echo "❌ This script must be sourced to work correctly."
  echo "➡️ Please run:"
  echo "    source ${(%):-%x}" # Use Zsh's way to get script path
  exit 1
fi

echo "🚀 Starting Node.js environment setup..."
echo

# Source NVM installer script
if [ -f "$(dirname "${(%):-%x}")/nvm-install.sh" ]; then
  echo -e "\n📥 Running NVM installer..."
  source "$(dirname "${(%):-%x}")/nvm-install.sh"
else
  echo "⚠️ nvm-install.sh not found. Skipping NVM installation."
fi
echo

# Source PM installer script
if [ -f "$(dirname "${(%):-%x}")/pm-install.sh" ]; then
  echo -e "\n📥 Running Package Manager installer..."
  source "$(dirname "${(%):-%x}")/pm-install.sh"
else
  echo "⚠️ pm-install.sh not found. Skipping Package Manager installation."
fi
echo

echo -e "\n✅ Node.js environment setup complete."
echo "💡 Remember to add any alias commands you agreed to permanently in your shell profile (e.g. ~/.bashrc or ~/.zshrc) if you want them to persist between sessions."
