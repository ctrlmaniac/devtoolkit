#!/usr/bin/env bash
# env.sh - Centralized environment and path configuration for devtoolkit
#
# USAGE
#  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#  source "$SCRIPT_DIR/path/to/env.sh"
#

set -euo pipefail

# Resolve root path of the repository
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export ROOT_DIR

# Resolve main devtoolkit path
DEVTOOLKIT="$ROOT_DIR/devtoolkit"
export DEVTOOLKIT

# Utils
export UTIL_IO="$DEVTOOLKIT/utils/io.sh"
export UTIL_CONFIG="$DEVTOOLKIT/utils/config.sh"

# Optional: set default emoji theme (can be overridden by user)
export LOG_EMOJI_THEME="${LOG_EMOJI_THEME:-fun}"

# resolve_path_to <relative_path_from_devtoolkit>
# Usage: source "$(resolve_path_to utils/log.sh)"
resolve_path_to() {
  local relative_path="$1"
  echo "$DEVTOOLKIT/$relative_path"
}
