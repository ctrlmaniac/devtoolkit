#!/usr/bin/env bash
# devtoolkit/libs/help/_main.sh
#
# Print the main help screen for the devtoolkit CLI.
#
# USAGE
#   print_main_help
#
# DESCRIPTION
#   Displays a styled CLI overview with available commands, grouped
#   by category, mimicking the GitHub CLI (`gh`) help layout.
#
# DEPENDS ON
#   - utils/io/log.sh      for log_info, log_success, etc.
#   - utils/tty/clear-console.sh  for clear_console

# Get current script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../env.sh
source "$SCRIPT_DIR/../../env.sh"

# shellcheck source=../../utils/io.sh
source "$UTIL_IO"

# shellcheck source=../../utils/tty.sh
source "$UTIL_TTY"

print_main_help() {
  clear_console

  log_bold "🧰  devtoolkit - Bootstrap your web development environment on Linux"
  echo
  log_info "USAGE"
  log_plain "  devtoolkit <command> <subcommand> [flags]"
  echo

  log_info "CORE COMMANDS"
  log_plain "  config:         Manage devtoolkit configurations"
  log_plain "  sys:            Manage system dependencies and tools"
  log_plain "  git:            Configure Git and related tools"
  log_plain "  github:         GitHub integrations (SSH keys, setup, etc.)"
  echo

  log_info "UTILITY COMMANDS"
  log_plain "  doctor:         Run environment diagnostics"
  log_plain "  help:           Show help for a specific command"
  log_plain "  version:        Show devtoolkit version"
  echo

  log_info "FLAGS"
  log_plain "  --help          Show help for command"
  log_plain "  --version       Show devtoolkit version"
  echo

  log_info "EXAMPLES"
  log_plain "  devtoolkit config log-theme ascii"
  log_plain "  devtoolkit sys install nodejs"
  log_plain "  devtoolkit github ssh-key check"
  echo

  log_info "LEARN MORE"
  log_plain "  Run 'devtoolkit <command> --help' for more info on a command."
  log_plain "  Read the docs at https://github.com/webnodex/devtoolkit"
}
