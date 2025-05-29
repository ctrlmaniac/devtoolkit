#!/usr/bin/env bash
# shellcheck shell=bash
set -euo pipefail
source "$DEVTOOLKIT/utils/log.sh"

read_confirm_action() {
  local message="$1"
  local next_action="$2"
  local default="yes"

  while true; do
    printf "👉 %s [yes/no] (default: %s): " "$message" "$default"
    IFS= read -r input || true
    input="${input,,}" # lowercase

    case "${input:-$default}" in
      y|yes|1)
        log_success "Confirmed."
        if declare -f "$next_action" >/dev/null; then
          "$next_action"
        elif [[ "$next_action" == "abort" ]]; then
          log_error "Aborted."
          exit 1
        fi
        return 0
        ;;
      n|no|0)
        log_warn "Declined."
        return 1
        ;;
      *)
        log_error "Invalid input. Please type yes or no."
        ;;
    esac
  done
}
