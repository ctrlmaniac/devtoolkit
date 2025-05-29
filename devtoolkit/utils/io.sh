#!/usr/bin/env bash
# devtoolkit/utils/io.sh
#
# Aggregate IO utilities for printing, outputting, reading, confirming, etc.
#
# Loads:
#   - io/confirm.sh
#   - io/log.sh
#   - io/read-choice.sh
#   - io/read.sh

# Determine directory of current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=io/confirm.sh
source "$SCRIPT_DIR/io/confirm.sh"

# shellcheck source=io/log.sh
source "$SCRIPT_DIR/io/log.sh"

# shellcheck source=io/read-choice.sh
source "$SCRIPT_DIR/io/read-choice.sh"

# shellcheck source=io/read.sh
source "$SCRIPT_DIR/io/read.sh"
