#!/usr/bin/env bash
# devtoolkit/utils/set-log-emojis.sh
#
# Configure emoji themes for log output
#
# USAGE
#   export LOG_EMOJI_THEME=ascii   # fun | ascii | minimal | ci
#   source devtoolkit/utils/set-log-emojis.sh
#
# THEMES:
#   fun      Colorful emojis (default)
#   ascii    ASCII-safe symbols
#   minimal  No emojis or tags (quiet-friendly)
#   ci       GitHub Actions log annotations (::info:: etc.)
#

set -euo pipefail

# Determine the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../env.sh
source "$SCRIPT_DIR/../../env.sh"

# shellcheck disable=SC1090
source "$UTIL_IO"

set_log_emojis() {
  local theme="${1:-fun}"

  case "$theme" in
  fun)
    export LOG_INFO_EMOJI="ℹ️ "
    export LOG_SUCCESS_EMOJI="✅"
    export LOG_WARN_EMOJI="⚠️ "
    export LOG_ERROR_EMOJI="❌"
    export LOG_DEBUG_EMOJI="🔍"
    ;;
  ascii)
    export LOG_INFO_EMOJI="[INFO]"
    export LOG_SUCCESS_EMOJI="[ OK ]"
    export LOG_WARN_EMOJI="[WARN]"
    export LOG_ERROR_EMOJI="[FAIL]"
    export LOG_DEBUG_EMOJI="[DBG]"
    ;;
  minimal)
    export LOG_INFO_EMOJI=""
    export LOG_SUCCESS_EMOJI=""
    export LOG_WARN_EMOJI=""
    export LOG_ERROR_EMOJI=""
    export LOG_DEBUG_EMOJI=""
    ;;
  ci)
    export LOG_INFO_EMOJI="::info::"
    export LOG_SUCCESS_EMOJI="::success::"
    export LOG_WARN_EMOJI="::warning::"
    export LOG_ERROR_EMOJI="::error::"
    export LOG_DEBUG_EMOJI="::debug::"
    ;;
  *)
    log_error "Unknown emoji theme: $theme"
    log_info "Available themes: fun, ascii, minimal, ci"
    return 1
    ;;
  esac

  if [[ -z "${DEVTOOLKIT_QUIET:-}" ]]; then
    log_success "Emoji theme set to '$theme'"
  fi
}

# Auto-apply if declared
if [[ -n "${LOG_EMOJI_THEME:-}" ]]; then
  set_log_emojis "$LOG_EMOJI_THEME"
fi
