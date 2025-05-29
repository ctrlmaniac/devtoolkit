#!/usr/bin/env bash
set -euo pipefail

# DEVTOOLKIT is inherited from the parent script (bin/devtoolkit)
# and should be an absolute path to the devtoolkit directory.
# Source env.sh to get the resolve_path_to function and other configurations.
if [ -n "$DEVTOOLKIT" ] && [ -f "$DEVTOOLKIT/env.sh" ]; then
  # The shellcheck source path is relative to this command script's location.
  # If mycommand.sh is in devtoolkit/commands/, then env.sh is at ../env.sh
  # shellcheck source=../env.sh
  source "$DEVTOOLKIT/env.sh"
else
  echo "Error: DEVTOOLKIT not set or $DEVTOOLKIT/env.sh not found in commands/mycommand.sh." >&2
  exit 1
fi

# Now you can use resolve_path_to for sourcing other scripts.
# Example: sourcing a utility from the utils directory.
# log.sh is at devtoolkit/utils/log.sh. Relative to this script, it's ../utils/log.sh
# shellcheck source=../utils/log.sh
source "$(resolve_path_to "utils/log.sh")"

# Example: sourcing a shared library within the commands directory itself,
# e.g., devtoolkit/commands/common_lib.sh
# shellcheck source=common_lib.sh
# source "$(resolve_path_to "commands/common_lib.sh")"

log_info "Executing mycommand..."
# ... rest of your command logic ...
