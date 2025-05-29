#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# log.sh - Logging utilities for devtoolkit
#
# 🧰 USAGE
#   export DEVTOOLKIT_QUIET=1            # Suppress all output
#   export LOG_EMOJI_THEME=ascii         # fun | ascii | ci
#   export LOG_SUCCESS_EMOJI="🚀"         # Override emoji
#   source devtoolkit/utils/log.sh
#
#   log_info "Installing Node.js"
#   log_success "Node.js installed"
#   log_warn "This may take a while"
#   log_error "Installation failed"
# -----------------------------------------------------------------------------

set -euo pipefail

# Default emoji values (used if no override present)
: "${LOG_INFO_EMOJI:="ℹ️ "}"
: "${LOG_SUCCESS_EMOJI:="✅"}"
: "${LOG_WARN_EMOJI:="⚠️ "}"
: "${LOG_ERROR_EMOJI:="❌"}"
: "${LOG_DEBUG_EMOJI:="🐛"}"

# Print only if quiet mode is disabled
_log_print() {
  if [[ "${DEVTOOLKIT_QUIET:-0}" -ne 1 ]]; then
    printf "%s\n" "$*"
  fi
}

# Public logging functions
log() {
  _log_print "$*"
}

log_info() {
  _log_print "${LOG_INFO_EMOJI} $*"
}

log_success() {
  _log_print "${LOG_SUCCESS_EMOJI} $*"
}

log_warn() {
  if [[ "${DEVTOOLKIT_QUIET:-0}" -ne 1 ]]; then
    printf "%s\n" "${LOG_WARN_EMOJI} $*" >&2
  fi
}

log_error() {
  if [[ "${DEVTOOLKIT_QUIET:-0}" -ne 1 ]]; then
    printf "%s\n" "${LOG_ERROR_EMOJI} $*" >&2
  fi
}

log_debug() {
  _log_print "${LOG_DEBUG_EMOJI} $*"
}
