#!/usr/bin/env bash
# devtoolkit/utils/cli.sh
#

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=cli/command-handler.sh
source "$SCRIPT_DIR/cli/command-hadler.sh"

# shellcheck source=cli/help-handler.sh
source "$SCRIPT_DIR/cli/help-handler.sh"
