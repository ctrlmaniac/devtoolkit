#!/usr/bin/env bash
# devtoolkit/commands/config/log-theme.sh
#
# USAGE:
#   devtoolkit config log-theme <fun|ascii|minimal|ci>
#   devtoolkit help config log-theme

set -euo pipefail

# Get current script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../env.sh
source "$SCRIPT_DIR/../../env.sh"

# shellcheck disable=SC1090
source "$UTIL_IO"

# shellcheck disable=SC1090
source "$UTIL_CONFIG"

log_theme_config() {
  local theme="${1:-}"
  if [[ -z "$theme" ]]; then
    log_error "Missing theme name."
    log_info "Usage: devtoolkit config log-theme <fun|ascii|minimal|ci>"
    return 1
  fi

  if set_log_emojis "$theme"; then
    log_success "Emoji theme set to '$theme'"
  else
    log_error "Invalid emoji theme: '$theme'"
    log_info "Available: fun, ascii, minimal, ci"
    return 1
  fi
}

# Dispatch
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  log_info "🖌️  Set log emoji theme"
  echo
  log_info "USAGE"
  log_plain "  devtoolkit config log-theme <fun|ascii|minimal|ci>"
  echo
  log_info "EXAMPLES"
  log_plain "  devtoolkit config log-theme ascii"
  exit 0
else
  log_theme_config "$@"
fi
