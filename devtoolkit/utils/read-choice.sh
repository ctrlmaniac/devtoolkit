#!/usr/bin/env bash
# shellcheck shell=bash

# This script defines the read_choice function which prompts the user
# to select one option from a list, either by number or exact string match.
# It supports a default value and loops until valid input is given.
#
# Usage example:
#
#   # Declare a variable to store the result
#   local selected_option
#
#   # Call read_choice with prompt, default index, result variable, and options
#   read_choice "Pick a color" 1 selected_option red green blue yellow
#
#   # Now $selected_option contains the chosen option (e.g., "green")
#
# Parameters:
#   $1 = Prompt string to display
#   $2 = Default choice index (1-based)
#   $3 = Name of variable to store result (passed by nameref)
#   $4..$n = List of option strings
#
# Returns:
#   Sets the variable named by $3 to the selected option string

# Determine the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../env.sh
source "$SCRIPT_DIR../env.sh"

read_choice() {
  local prompt="$1"
  local default="$2"

  # 'result_var' is a nameref to the variable where the chosen option is stored
  local -n result_var=$3

  shift 3
  local options=("$@")

  while true; do
    local i=1
    for opt in "${options[@]}"; do
      log_info "  - $i) $opt"
      i=$((i + 1))
    done

    printf "👉 %s [1-%d, default %s]: " "$prompt" "${#options[@]}" "$default"
    local choice
    IFS= read -r choice || true
    choice="${choice:-$default}"

    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
      result_var="${options[choice - 1]}"
      return 0
    fi

    for opt in "${options[@]}"; do
      if [[ "$opt" == "$choice" ]]; then
        # shellcheck disable=SC2034
        result_var="$opt"
        return 0
      fi
    done

    log_error "Invalid input. 🤔 Did you mean:"
    for opt in "${options[@]}"; do
      log_info "  - $opt"
    done
  done
}
