#!/usr/bin/env bash
set -euo pipefail

print_usage() {
  cat <<EOF

🔐  SSH Key Generation Wizard for GitHub - Usage & Options

📌 Usage:
    $ROOT/scripts/github/ssh-key-gen.sh [OPTIONS]

✨ Features:
  ✔️ Checks if ssh-keygen is installed
  ✔️ Prompts for your GitHub email address
  ✔️ Asks for SSH key file name (default: github-<user>-ed25519)
  ✔️ Ensures ~/.ssh directory exists with proper permissions
  ✔️ Checks for existing keys and confirms before overwriting
  ✔️ Prompts for an optional passphrase
  ✔️ Generates an Ed25519 SSH key pair
  ✔️ Displays your public key with GitHub upload instructions
  ✔️ Optionally adds the key to ssh-agent
  ✔️ Optionally copies the public key to clipboard

💡 Notes:
  - Requires support scripts from:
    $ROOT/scripts/core/_logging.sh
    $ROOT/scripts/core/_checks.sh
  - Run this script from the repository root or adjust paths as needed.
  - Designed for easy, consistent GitHub SSH key setup.

Options:
  -h, --help     Show this help message and exit.

EOF
}
