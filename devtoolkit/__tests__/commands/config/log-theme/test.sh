#!/usr/bin/env bash
# Simple test for theme setting

set -euo pipefail

# shellcheck source=../../env.sh
source "$(dirname "${BASH_SOURCE[0]}")/../../env.sh"

# shellcheck source=devtoolkit/utils/log.sh
source "$(resolve_path_to utils/log.sh)"

# shellcheck source=devtoolkit/utils/set-log-emojis.sh
source "$(resolve_path_to utils/set-log-emojis.sh)"

test_log_theme_ascii() {
  set_log_emojis ascii
  [[ "$LOG_ERROR_EMOJI" == "[FAIL]" ]] || {
    echo "Expected [FAIL], got: $LOG_ERROR_EMOJI"
    return 1
  }
  log_success "Test passed"
}

test_log_theme_ascii
