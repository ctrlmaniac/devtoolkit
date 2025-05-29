#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# log-theme.sh - CLI to switch log emoji theme for devtoolkit
#
# Usage:
#   source devtoolkit/utils/log-theme.sh
#   devtoolkit_log_theme ascii
#   devtoolkit_log_theme fun
#   devtoolkit_log_theme ci
#
# This script exports appropriate environment variables to override emojis
# and sources log.sh to update them immediately in the current shell.
# -----------------------------------------------------------------------------

set -euo pipefail

# Usage help
print_usage() {
  cat <<EOF
Usage: devtoolkit_log_theme [THEME]

THEME options:
  fun    - Colorful emojis (default)
  ascii  - ASCII-friendly emojis
  ci     - Minimal/no emoji (CI-friendly)

Example:
  devtoolkit_log_theme ascii
EOF
}

# Apply theme by setting emoji environment variables
devtoolkit_log_theme() {
  local theme="${1:-fun}"

  case "$theme" in
  fun)
    export LOG_INFO_EMOJI="ℹ️ "
    export LOG_SUCCESS_EMOJI="✅"
    export LOG_WARN_EMOJI="⚠️ "
    export LOG_ERROR_EMOJI="❌"
    export LOG_DEBUG_EMOJI="🐛"
    ;;
  ascii)
    export LOG_INFO_EMOJI="[i]"
    export LOG_SUCCESS_EMOJI="[OK]"
    export LOG_WARN_EMOJI="[!]"
    export LOG_ERROR_EMOJI="[ERR]"
    export LOG_DEBUG_EMOJI="[DBG]"
    ;;
  ci)
    export LOG_INFO_EMOJI=""
    export LOG_SUCCESS_EMOJI=""
    export LOG_WARN_EMOJI=""
    export LOG_ERROR_EMOJI=""
    export LOG_DEBUG_EMOJI=""
    ;;
  *)
    printf "❌ Invalid theme '%s'.\n" "$theme" >&2
    print_usage
    return 1
    ;;
  esac

  # Source log.sh to apply changes immediately
  if [[ -f "$(dirname "${BASH_SOURCE[0]}")/log.sh" ]]; then
    # shellcheck source=/dev/null
    source "$(dirname "${BASH_SOURCE[0]}")/log.sh"
  else
    printf "❌ Could not find log.sh to source. Please source manually.\n" >&2
    return 1
  fi

  printf "✅ Log emoji theme set to '%s'.\n" "$theme"
}

# If called with no args or --help, print usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [[ $# -eq 0 || $1 == "--help" || $1 == "-h" ]]; then
    print_usage
    exit 0
  fi
  devtoolkit_log_theme "$1"
fi
