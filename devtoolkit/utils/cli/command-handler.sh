#!/usr/bin/env bash
# devtoolkit/utils/cli/command-handler.sh
#Handles CLI command logic including help fallback

set -euo pipefail

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../env.sh"

# shellcheck disable=SC1090
source "$UTIL_IO"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/help-handler.sh"

# handle_command <command> <actions_assoc_array> <args...>
handle_command() {
  local command_name="$1"
  shift
  declare -n actions="$1"
  shift

  local action="${1:-}"

  if [[ -z "$action" || "$action" =~ ^-h|--help$ ]]; then
    "_print_${command_name}_help"
    return 0
  fi

  if [[ -n "${actions[$action]+_}" ]]; then
    shift
    "${actions[$action]}" "$@"
  else
    log_error "Unknown subcommand: $action"
    log_info "Use \`devtoolkit $command_name --help\` to see available subcommands."
    exit 1
  fi
}
