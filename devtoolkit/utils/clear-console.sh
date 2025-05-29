#!/usr/bin/env bash
# devtoolkit/utils/clear-console.sh
#
# 🧰 Utility to clear the terminal console screen
#
# ℹ️ Clears the console using the `clear` command if available,
#    otherwise falls back to the ANSI escape sequence `\033c`.
#
# 🧰 USAGE
#   source devtoolkit/utils/clear-console.sh
#   clear_console
#
# 💡 DESCRIPTION:
#   Use this function in scripts or interactive sessions to provide
#   a clean console screen reliably across different environments.
#

# Clears the terminal console screen.
# Usage: clear_console
clear_console() {
  command -v clear &>/dev/null && clear || printf "\033c"
}
