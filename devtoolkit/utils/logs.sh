#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

# General printf wrapper
log() {
  printf "%s\n" "$*"
}

log_info() {
  printf "ℹ️ %s\n" "$*"
}

log_success() {
  printf "✅ %s\n" "$*"
}

log_warn() {
  printf "⚠️ %s\n" "$*" >&2
}

log_error() {
  printf "❌ %s\n" "$*" >&2
}
