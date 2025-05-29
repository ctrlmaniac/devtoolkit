#!/usr/bin/env bash
# devtoolkit/utils/read-choice.sh
#
# Prompt user to select one option from a list
#
# USAGE
#   source devtoolkit/utils/read-choice.sh
#   local selected_option
#   read_choice "Pick a color" 1 selected_option red green blue yellow
#
# DESCRIPTION
#   Prompts the user to select an option by entering its number or exact
#   string match. Supports a default choice and loops until valid input
#   is given.
#
# PARAMETERS
#   $1  - Prompt message to display
#   $2  - Default choice index (1-based)
#   $3  - Name of variable to store selected option (passed by nameref)
#   $4+ - List of option strings
#
# RETURNS
#   Sets the variable named by $3 to the chosen option string.
#
# DEPENDS ON
#   - env.sh           (optional) environment setup
#   - utils/log.sh     provides log_info, log_error for user feedback
#

# Determine the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../env.sh
source "$SCRIPT_DIR/../env.sh"

# shellcheck source=../utils/log.sh
source "$SCRIPT_DIR/log.sh"

read_choice() {
  local prompt="$1"
  local default_idx="$2"
  local -n result_var="$3"
  shift 3
  local options=("$@")

  # Validate default index
  if ((default_idx < 1 || default_idx > ${#options[@]})); then
    log_warn "Default index $default_idx is out of range, resetting to 1."
    default_idx=1
  fi

  while true; do
    # Display options numbered
    local i=1
    for opt in "${options[@]}"; do
      log_info "  - $i) $opt"
      ((i++))
    done

    # Prompt user
    printf "Select an option [1-%d, default %d]: %s " "${#options[@]}" "$default_idx" "$prompt"
    local choice
    IFS= read -r choice || true
    choice="${choice:-$default_idx}"

    # If input is number in range, select by index
    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
      result_var="${options[choice - 1]}"
      return 0
    fi

    # Otherwise, check if input matches an option exactly
    for opt in "${options[@]}"; do
      if [[ "$opt" == "$choice" ]]; then
        # Assign selected option to the caller's variable via nameref
        # shellcheck disable=SC2034
        result_var="${options[choice - 1]}"
        return 0
      fi
    done

    # Invalid input, show error and options again
    log_error "Invalid input. Please enter a number from 1 to ${#options[@]} or the exact option name."
  done
}
