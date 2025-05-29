#!/usr/bin/env bash
# devtoolkit/utils/cli/help-handler.sh
# Constructs and prints help output for CLI commands

set -euo pipefail

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../env.sh"

# shellcheck disable=SC1090
source "$UTIL_IO"

# handle_help <command> <desc> <usage> <core_commands> <flags> <examples> <footer>
handle_help() {
  local cmd="$1"
  local desc="$2"
  local usage="$3"
  local core="$4"
  local flags="$5"
  local examples="$6"
  local footer="$7"

  log_info "📦  $cmd"
  echo
  log_info "📝  $desc"
  echo
  log_info "🚀  Usage"
  echo -e "   $usage"
  echo
  log_info "📌  Core Commands"
  echo -e "$core"
  echo
  log_info "🧰  Flags"
  echo -e "$flags"
  echo
  log_info "💡  Examples"
  echo -e "$examples"
  echo
  log_info "ℹ️  $footer"
}
