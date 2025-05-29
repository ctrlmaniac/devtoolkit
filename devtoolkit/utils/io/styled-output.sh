#!/usr/bin/env bash
# devtoolkit/utils/io/styled-output.sh
#
# Styled terminal output helpers: boxed text, aligned emojis, etc.
#
# USAGE
#   source devtoolkit/utils/io/styled-output.sh
#   print_boxed "Hello, world!"
#
# DESCRIPTION
#   This module provides stylized output functions for CLI UIs,
#   including box-wrapped messages, emoji-aligned columns, and more.
#
# DEPENDS ON
#   - io/log.sh   for log_info and log_note
#

set -euo pipefail

# Load logging helpers
# shellcheck source=log.sh
source "$(dirname "${BASH_SOURCE[0]}")/log.sh"

# Print a boxed message
# Usage: print_boxed "Message to show"
print_boxed() {
  local message="$1"
  local border_length=$((${#message} + 8)) # Padding for spacing
  local padding=3

  log_info ""
  log_info "┌$(printf '%*s' "$border_length" '' | tr ' ' '─')┐"
  log_info "│$(printf '%*s' "$padding" '')$message$(printf '%*s' "$padding" '')│"
  log_info "└$(printf '%*s' "$border_length" '' | tr ' ' '─')┘"
  log_info ""
}

# Print a header-style title (🔧 Section Title)
# Usage: print_header "🔧" "Section Title"
print_header() {
  local emoji="$1"
  local title="$2"
  log_note ""
  log_note "$emoji  $title"
  log_note ""
}

# Print a two-column label:value pair
# Usage: print_kv "Label" "Value"
print_kv() {
  local key="$1"
  local value="$2"
  printf "  🟢  %-20s %s\n" "$key" "$value"
}
