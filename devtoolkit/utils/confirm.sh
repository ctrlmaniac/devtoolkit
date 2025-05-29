#!/usr/bin/env bash
# devtoolkit/utils/confirm.sh
#
# Ask user to confirm before taking an action
#
# 🧰 USAGE
#   source devtoolkit/utils/confirm.sh
#   read_confirm_action "Proceed with cleanup?" "cleanup_function"
#   read_confirm_action "Reset configs?" "abort"  # Use "abort" to exit on decline
#
# 📝 DESCRIPTION
#   Prompts the user for yes/no input and triggers the specified action
#   if confirmed. On "abort", it exits with code 1.
#
# 🔗 DEPENDS ON
#   - env.sh           → provides resolve_path_to
#   - utils/log.sh     → provides log_success, log_warn, log_error
#

set -euo pipefail

# Get current script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../env.sh
source "$SCRIPT_DIR/../env.sh"

# shellcheck source=log.sh
source "$SCRIPT_DIR/log.sh"

read_confirm_action() {
  local message="$1"
  local next_action="$2"
  local default="yes"

  while true; do
    printf "👉 %s [yes/no] (default: %s): " "$message" "$default"
    IFS= read -r input || true
    input="${input,,}" # lowercase

    case "${input:-$default}" in
    y | yes | 1)
      log_success "Confirmed."
      if declare -f "$next_action" >/dev/null; then
        "$next_action"
      elif [[ "$next_action" == "abort" ]]; then
        log_error "Aborted."
        exit 1
      fi
      return 0
      ;;
    n | no | 0)
      log_warn "Declined."
      return 1
      ;;
    *)
      log_error "Invalid input. Please type yes or no."
      ;;
    esac
  done
}
