#!/usr/bin/env bash
# devtoolkit/utils/log.sh
#
# Logging utilities for devtoolkit
#
# Provides standardized logging functions with emoji support and quiet mode
#
# USAGE
#   export DEVTOOLKIT_QUIET=1            # Suppress all output
#   export LOG_EMOJI_THEME=ascii         # Select emoji theme: fun | ascii | ci
#   export LOG_SUCCESS_EMOJI="🚀"         # Override individual emojis if desired
#   source devtoolkit/utils/log.sh
#
# FUNCTIONS
#   log           - Generic log output to stdout
#   log_info      - Informational messages (stdout, prefixed)
#   log_success   - Success messages (stdout, prefixed)
#   log_warn      - Warning messages (stderr, prefixed)
#   log_error     - Error messages (stderr, prefixed)
#   log_debug     - Debug messages (stdout, prefixed)
#
# ENVIRONMENT VARIABLES
#   DEVTOOLKIT_QUIET    - If set to 1, suppresses all log output
#   LOG_INFO_EMOJI      - Emoji or prefix for info logs (default "ℹ️ ")
#   LOG_SUCCESS_EMOJI   - Emoji or prefix for success logs (default "✅")
#   LOG_WARN_EMOJI      - Emoji or prefix for warnings (default "⚠️ ")
#   LOG_ERROR_EMOJI     - Emoji or prefix for errors (default "❌")
#   LOG_DEBUG_EMOJI     - Emoji or prefix for debug logs (default "🐛")
#

set -euo pipefail

# Default emoji values (used if no override present)
: "${LOG_INFO_EMOJI:="ℹ️ "}"
: "${LOG_SUCCESS_EMOJI:="✅"}"
: "${LOG_WARN_EMOJI:="⚠️ "}"
: "${LOG_ERROR_EMOJI:="❌"}"
: "${LOG_DEBUG_EMOJI:="🐛"}"

# Internal: Print only if quiet mode is disabled
_log_print() {
  if [[ "${DEVTOOLKIT_QUIET:-0}" -ne 1 ]]; then
    printf "%s\n" "$*"
  fi
}

# Public logging functions

# log - Generic log output to stdout without any prefix or emoji
# Usage: log "message"
log() {
  _log_print "$*"
}

# log_info - Log informational messages to stdout with info emoji/prefix
# Usage: log_info "Informational message"
log_info() {
  _log_print "${LOG_INFO_EMOJI} $*"
}

# log_success - Log success messages to stdout with success emoji/prefix
# Usage: log_success "Success message"
log_success() {
  _log_print "${LOG_SUCCESS_EMOJI} $*"
}

# log_warn - Log warning messages to stderr with warning emoji/prefix
# Usage: log_warn "Warning message"
log_warn() {
  if [[ "${DEVTOOLKIT_QUIET:-0}" -ne 1 ]]; then
    printf "%s\n" "${LOG_WARN_EMOJI} $*" >&2
  fi
}

# log_error - Log error messages to stderr with error emoji/prefix
# Usage: log_error "Error message"
log_error() {
  if [[ "${DEVTOOLKIT_QUIET:-0}" -ne 1 ]]; then
    printf "%s\n" "${LOG_ERROR_EMOJI} $*" >&2
  fi
}

# log_debug - Log debug messages to stdout with debug emoji/prefix
# Usage: log_debug "Debug message"
log_debug() {
  _log_print "${LOG_DEBUG_EMOJI} $*"
}
