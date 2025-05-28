#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$REPO_ROOT/scripts/core/_checks.sh"
source "$REPO_ROOT/scripts/core/_logging.sh"
source "$REPO_ROOT/scripts/core/_print-header.sh"   # if you want to use print_header function
source "$REPO_ROOT/scripts/github/ssh-key-gen.help.sh"  # if you need your help text

main() {
  local ssh_target="git@github.com"
  local private_key_path="$HOME/.ssh/id_rsa"
  local ssh_output=""
  local ssh_exit_code=0

  if [[ ! -f "$private_key_path" ]]; then
    log_error "SSH private key not found at '$private_key_path'."
    return 1
  fi

  ssh_output=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=no -i "$private_key_path" "$ssh_target" 2>&1) || ssh_exit_code=$?

  case "$ssh_output" in
    Hi\ *"!' You've successfully authenticated"*)
      log_success "✅ SUCCESS: Authentication with '${ssh_target}' was successful using this key."
      printf '%s\n' "$ssh_output"
      ;;
    *"Permission denied (publickey)"*)
      log_error "❌ FAILURE: Authentication with '${ssh_target}' failed. Permission denied by server."
      printf '%s\n' "$ssh_output"
      log_warn "  - If the key is passphrase-protected, it must be added to your ssh-agent (e.g., 'ssh-add \"$private_key_path\"')."
      ;;
    *"Could not resolve hostname"*|*"Connection refused"*)
      log_error "❌ FAILURE: SSH connection to '${ssh_target}' failed."
      printf '%s\n' "$ssh_output"
      ;;
    *)
      log_warn "⚠️ WARNING: Unexpected SSH authentication response."
      printf '%s\n' "$ssh_output"
      ;;
  esac

  return "${ssh_exit_code:-0}"
}

main "$@"
