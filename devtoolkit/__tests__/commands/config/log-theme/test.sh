#!/usr/bin/env bash
# Simple test for theme setting

set -euo pipefail

source "$ROOT/devtoolkit/utils/set-log-emojis.sh"
source "$ROOT/devtoolkit/utils/log.sh"

test_log_theme_ascii() {
  set_log_emojis ascii
  [[ "$LOG_ERROR_EMOJI" == "[FAIL]" ]] || {
    echo "Expected [FAIL], got: $LOG_ERROR_EMOJI"
    return 1
  }
  log_success "Test passed"
}

test_log_theme_ascii
