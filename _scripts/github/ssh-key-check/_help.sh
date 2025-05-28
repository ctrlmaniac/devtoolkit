#!/usr/bin/env bash
set -euo pipefail

help() {
  cat <<EOF

🔐 SSH Key Authentication Check - Usage & Options

📌 Usage:
    \$ROOT/scripts/github/ssh-key-check.sh

This interactive script helps verify if a given SSH private key can successfully authenticate with GitHub.

✨ Features:
  ✔️ Prompts for a key file path or name
  ✔️ Validates file existence and permissions
  ✔️ Tries authenticating with GitHub via SSH
  ✔️ Interprets and explains success/failure output

💡 Notes:
  - Expects SSH installed (via core/_checks.sh)
  - Uses these helpers:
      scripts/github/ssh-key-check/_help.sh
      scripts/github/ssh-key-check/_prompt-key-path.sh

EOF
}
