#!/usr/bin/env bash
# devtoolkit/utils/io.sh
#
# The IO module offers utilities for printing, outputting and reading
#
# FUNCTIONS:
#   - read_set-log-emojis-theme_action
#   - etc
#

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=io/confirm.sh
source "$SCRIPT_DIR/config/log-theme.sh"

# shellcheck source=config/set-log-emojis.sh
source "$SCRIPT_DIR/config/set-log-emojis.sh"
