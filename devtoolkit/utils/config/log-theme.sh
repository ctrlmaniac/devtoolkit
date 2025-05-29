#!/usr/bin/env bash
# devtoolkit/utils/log-theme.sh
#
# CLI to switch log emoji theme for devtoolkit
#
# This script sets environment variables to override emoji themes for logging
# and sources log.sh to apply the changes immediately in the current shell.
#
# USAGE
#   source devtoolkit/utils/log-theme.sh
#   devtoolkit_log_theme ascii
#   devtoolkit_log_theme fun
#   devtoolkit_log_theme ci
#
# THEMES:
#   fun      Colorful emojis (default)
#   ascii    ASCII-safe symbols
#   minimal  No emojis or tags (quiet-friendly)
#   ci       GitHub Actions log annotations (::info:: etc.)
#

set -euo pipefail

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../env.sh
source "$SCRIPT_DIR/../../env.sh"

# shellcheck disable=SC1090
source "$UTIL_IO"

# print_usage - Display usage instructions
_print_usage() {
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

# devtoolkit_log_theme - Set emoji environment variables based on THEME
# Usage: devtoolkit_log_theme [THEME]
#   THEME - One of fun, ascii, ci (default: fun)
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

  # Source log.sh to apply emoji changes immediately
  local SCRIPT_DIR
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [[ -f "$UTIL_IO" ]]; then
    # shellcheck disable=SC1091
    # shellcheck disable=SC1090
    source "$UTIL_IO"
  else
    # Keep printf because IO module is not loaded
    printf "❌ Could not find log.sh to source. Please source manually.\n" >&2
    return 1
  fi

  printf "✅ Log emoji theme set to '%s'.\n" "$theme"

}

# If script executed directly, parse arguments and run
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [[ $# -eq 0 || $1 == "--help" || $1 == "-h" ]]; then
    _print_usage
    exit 0
  fi
  devtoolkit_log_theme "$1"
fi
