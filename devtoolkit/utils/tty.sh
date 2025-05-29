#!/usr/bin/env bash
# devtoolkit/utils/io.sh
#
# Terminal control utilities
#
# Loads:
#   - tty/clear-console.sh
#

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=tty/confirm.sh
source "$SCRIPT_DIR/tty/clear-console.sh"
