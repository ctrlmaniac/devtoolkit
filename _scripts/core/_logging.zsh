#!/usr/bin/env zsh
#
# Simple logging helpers for devtoolkit
#
# Usage:
#   log_info "Informational message"
#   log_success "Success message"
#   log_warn "Warning message"
#   log_error "Error message"
#
# Notes:
# - log_warn and log_error output to stderr
# - log_info and log_success output to stdout
#

# Prints an informational message to stdout
log_info() {
  print -r -- "[devtoolkit] ℹ️  $*"
}

# Prints a success message to stdout
log_success() {
  print -r -- "[devtoolkit] ✅ $*"
}

# Prints a warning message to stderr
log_warn() {
  print -r -- "[devtoolkit] ⚠️  $*" >&2
}

# Prints an error message to stderr
log_error() {
  print -r -- "[devtoolkit] ❌ $*" >&2
}
