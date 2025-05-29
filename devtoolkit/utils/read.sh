#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

# shellcheck source=../../env.sh
source "$(dirname "${BASH_SOURCE[0]}")/../../env.sh"

# shellcheck source=devtoolkit/utils/log.sh
source "$(resolve_path_to utils/log.sh)"

_prompt_with_validation() {
  local prompt="$1"
  local default="$2"
  local regex="${3:-}"
  local input

  while true; do
    printf "👉 %s [%s]: " "$prompt" "$default"
    IFS= read -r input || true
    input="${input:-$default}"

    if [[ -z "$regex" || "$input" =~ $regex ]]; then
      log_info "$input"
      REPLY="$input"
      return 0
    else
      log_error "Invalid input. Please try again."
    fi
  done
}

read_char() {
  _prompt_with_validation "$1" "${2:-1}" "${3:-^[a-zA-Z0-9]$}"
}

read_word() {
  _prompt_with_validation "$1" "${2:-}" "${3:-^[^[:space:]]+$}"
}

read_line() {
  _prompt_with_validation "$1" "${2:-}" "${3:-}"
}

read_multiline() {
  local prompt="$1"
  log_info "$prompt"
  log_info "(Press CTRL+D to finish)"
  local input
  input=$(</dev/stdin)
  log_info "$input"
  REPLY="$input"
}
