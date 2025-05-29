#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# log-theme.sh - Set emoji theme for devtoolkit logs
#
# 🧰 USAGE
#   devtoolkit config log-theme <fun|ascii|minimal|ci>
# -----------------------------------------------------------------------------

set -euo pipefail

# shellcheck source=../../env.sh
source "$(dirname "${BASH_SOURCE[0]}")/../../env.sh"

# shellcheck source=devtoolkit/utils/log.sh
source "$(resolve_path_to utils/log.sh)"

# shellcheck source=devtoolkit/utils/set-log-emojis.sh
source "$(resolve_path_to utils/set-log-emojis.sh)"

log_theme_config() {
  local theme="${1:-}"
  if [[ -z "$theme" ]]; then
    log_error "Missing theme name."
    log_info "Usage: devtoolkit config log-theme <fun|ascii|minimal|ci>"
    return 1
  fi

  if set_log_emojis "$theme"; then
    log_success "Emoji theme set to '$theme'"
  else
    log_error "Invalid emoji theme: '$theme'"
    log_info "Available: fun, ascii, minimal, ci"
    return 1
  fi
}
