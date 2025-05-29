#!/usr/bin/env bash
# devtoolkit/libs/help/_dispatch.sh
#
# Dispatch help output for specific commands or subcommands.
#
# USAGE:
#   help_dispatch <command> [subcommand]

# Get current script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../env.sh
source "$SCRIPT_DIR/../../env.sh"

# shellcheck source=../../utils/io.sh
source "$UTIL_IO"

help_dispatch() {
  local command="${1:-}"
  local subcommand="${2:-}"

  if [[ -z "$command" ]]; then
    log_error "Missing command for help."
    log_info "Usage: devtoolkit help <command> [subcommand]"
    return 1
  fi

  # Help for standalone command: commands/foo.sh
  if [[ -f "$DEVTOOLKIT/commands/${command}.sh" ]]; then
    bash "$DEVTOOLKIT/commands/${command}.sh" --help
    return $?

  # Help for subcommand: commands/foo/bar.sh
  elif [[ -n "$subcommand" && -f "$DEVTOOLKIT/commands/${command}/${subcommand}.sh" ]]; then
    bash "$DEVTOOLKIT/commands/${command}/${subcommand}.sh" --help
    return $?

  # Error
  else
    log_error "No such command: $command ${subcommand:-}"
    return 1
  fi
}
