#!/usr/bin/env bash
set -euo pipefail

prompt_for_ssh_private_key_path() {
  local default_ssh_dir="$HOME/.ssh"
  local username
  username="$(whoami)"
  local default_filename
  default_filename="github-${username}-ed25519"

  echo "This script will test an SSH private key, typically against GitHub."

  read -r -e -i "$default_filename" -p \
    "Enter key filename (from ${default_ssh_dir}/) or full/relative path: " user_key_specifier

  if [[ -z "$user_key_specifier" ]]; then
    log_error "Key input cannot be empty. Exiting."
    exit 1
  fi

  local resolved_path
  if [[ "$user_key_specifier" == */* || "$user_key_specifier" == ./* || "$user_key_specifier" == ../* ]]; then
    resolved_path="$user_key_specifier"
  else
    resolved_path="${default_ssh_dir}/${user_key_specifier}"
    echo
    log_info "Assuming key is in ${default_ssh_dir}/"
    log_info "Using resolved path: ${resolved_path}"
  fi

  export SSH_PRIVATE_KEY_PATH="$resolved_path"
}
