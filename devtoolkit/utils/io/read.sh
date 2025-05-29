#!/usr/bin/env bash
# devtoolkit/utils/read.sh
#
# Utility functions for reading validated user input from terminal
#
# FUNCTIONS
#   read_char       - Read a single character matching a regex (default alphanumeric)
#   read_word       - Read a single non-whitespace word
#   read_line       - Read a line of input, optionally with validation
#   read_multiline  - Read multiline input until EOF (Ctrl+D)
#
# INTERNAL
#   _prompt_with_validation - Core prompt with regex validation logic
#

set -euo pipefail

# Determine the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../env.sh
source "$SCRIPT_DIR/../env.sh"

# shellcheck source=log.sh
source "$SCRIPT_DIR/log.sh"

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
