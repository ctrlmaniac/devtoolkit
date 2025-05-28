#!/usr/bin/env bash
set -euo pipefail

print_usage() {
  cat <<EOF

🛠️  Git Configuration Wizard - Usage & Options

📌 Usage:
    $ROOT/scripts/git/config.sh

This interactive script helps you set up your global Git configuration with recommended settings.

✨ Features:
  ✔️ Check if Git is installed
  ✔️ Configure default branch name (e.g. main)
  ✔️ Set preferred Git editor (nano, vim, code --wait)
  ✔️ Configure line endings (core.autocrlf)
  ✔️ Set pull behavior (rebase, merge, preserve)
  ✔️ Set push behavior (current, simple, upstream, matching, nothing)
  ✔️ Configure diff tool (meld, kdiff3, vimdiff, code)
  ✔️ Set Git user.name and user.email
  ✔️ Show a summary of your Git settings

💡 Notes:
  - Requires these support scripts from:
    $ROOT/scripts/core/_logging.sh
    $ROOT/scripts/core/_checks.sh
  - Run this script from the repository root or adjust paths as needed.
  - Use this for easy, consistent Git global setup.

EOF
}

print_usage
