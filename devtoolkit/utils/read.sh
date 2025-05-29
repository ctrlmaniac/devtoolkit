#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

source "$DEVTOOLKIT/utils/log.sh"

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

read_choice() {
  local prompt="$1"
  local default="$2"
  local -n result_var=$3
  shift 3
  local options=("$@")

  while true; do
    local i=1
    for opt in "${options[@]}"; do
      log_info "  - $i) $opt"
      i=$((i + 1))
    done

    printf "👉 %s [1-%d, default %s]: " "$prompt" "${#options[@]}" "$default"
    local choice
    IFS= read -r choice || true
    choice="${choice:-$default}"

    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
      result_var="${options[choice - 1]}"
      return 0
    fi

    for opt in "${options[@]}"; do
      if [[ "$opt" == "$choice" ]]; then
        result_var="$opt"
        return 0
      fi
    done

    log_error "Invalid input. 🤔 Did you mean:"
    for opt in "${options[@]}"; do
      log_info "  - $opt"
    done
  done
}
