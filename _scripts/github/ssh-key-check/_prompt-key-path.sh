#!/usr/bin/env bash
set -euo pipefail

# Prompts the user for a key path, validates it, and returns it via echo
# Output: the resolved key path
prompt_key_path() {
  local default_ssh_dir="$HOME/.ssh"
  local default_filename
  default_filename="github-$(whoami)-ed25519"

  echo "This script will test an SSH private key, typically against GitHub."
  echo

  read -r -e -i "${default_filename}" \
    -p "Enter key filename (from ${default_ssh_dir}/) or full/relative path: " user_key_specifier

  if [[ -z "$user_key_specifier" ]]; then
    echo "Error: Key input cannot be empty. Exiting."
    exit 1
  fi

  local private_key_path
  if [[ "$user_key_specifier" == *"/"* ]] || [[ "$user_key_specifier" == ./* ]] || [[ "$user_key_specifier" == ../* ]]; then
    private_key_path="$user_key_specifier"
  else
    private_key_path="${default_ssh_dir}/${user_key_specifier}"
    echo
    echo "Assuming key '${user_key_specifier}' is in ${default_ssh_dir}/."
    echo "Using resolved path: ${private_key_path}"
  fi

  if [[ ! -f "$private_key_path" ]]; then
    echo "Error: Private key file not found at '${private_key_path}'. Exiting."
    exit 1
  fi

  if [[ ! -r "$private_key_path" ]]; then
    echo "Error: Private key file at '${private_key_path}' is not readable. Check permissions. Exiting."
    exit 1
  fi

  echo "$private_key_path"
}
