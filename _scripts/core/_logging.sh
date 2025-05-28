#!/usr/bin/env bash
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

log_info() {
  printf '[devtoolkit] ℹ️  %s\n' "$*"
}

log_success() {
  printf '[devtoolkit] ✅ %s\n' "$*"
}

log_warn() {
  printf '[devtoolkit] ⚠️  %s\n' "$*" >&2
}

log_error() {
  printf '[devtoolkit] ❌ %s\n' "$*" >&2
}
