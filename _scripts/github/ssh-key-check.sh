#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail
IFS=$'\n\t'

# Resolve ROOT (adjust as needed)
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load core helper functions
# shellcheck source=scripts/core/_logging.sh
source "$ROOT/scripts/core/_logging.sh"

# shellcheck source=scripts/core/_checks.sh
source "$ROOT/scripts/core/_checks.sh"

# Main function wrapping the entire script logic
main() {
  local ssh_target="git@github.com"
  local private_key_path="$HOME/.ssh/id_rsa"
  local ssh_output=""
  local ssh_exit_code=0

  # Check if SSH private key exists
  if [[ ! -f "$private_key_path" ]]; then
    log_error "SSH private key not found at '$private_key_path'."
    return 1
  fi

  # Test SSH authentication with quiet and no command mode
  ssh_output=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=no -i "$private_key_path" "$ssh_target" 2>&1) || ssh_exit_code=$?

  # Analyze SSH output with a case statement (no backslashes in pattern!)
  case "$ssh_output" in
    # Match: Hi <username>! You've successfully authenticated ...
    Hi\ *"!' You've successfully authenticated"*)
      log_success "✅ SUCCESS: Authentication with '${ssh_target}' was successful using this key."
      printf '%s\n' "$ssh_output"
      ;;

    # Match: Permission denied (publickey)
    *"Permission denied (publickey)"*)
      log_error "❌ FAILURE: Authentication with '${ssh_target}' failed. Permission denied by server."
      printf '%s\n' "$ssh_output"
      log_warn "  - If the key is passphrase-protected, it must be added to your ssh-agent (e.g., 'ssh-add \"$private_key_path\"')."
      ;;

    # Match: Could not resolve hostname or connection refused
    *"Could not resolve hostname"*|*"Connection refused"*)
      log_error "❌ FAILURE: SSH connection to '${ssh_target}' failed."
      printf '%s\n' "$ssh_output"
      ;;

    # Fallback: unknown response
    *)
      log_warn "⚠️ WARNING: Unexpected SSH authentication response."
      printf '%s\n' "$ssh_output"
      ;;
  esac

  # Return exit code from ssh command or 0 if none
  return "${ssh_exit_code:-0}"
}

# Execute main with passed args
main "$@"
