#!/usr/bin/env bash
# read-choice.sh - Read a user's choice from a numbered list of options.
#
# 📌 USAGE:
#   # source the environment and required utils
#   source "$(dirname "${BASH_SOURCE[0]}")/../../env.sh"
#   source "$(resolve_path_to utils/log.sh)"
#   source "$(resolve_path_to utils/read-choice.sh)"
#
#   local result=""
#   read_choice "Choose a theme" "1" result "fun" "ascii" "minimal" "ci"
#   echo "You chose: $result"
#
# 🔧 DEPENDS ON:
#   - log_info(), log_error() from utils/log.sh
#   - resolve_path_to() from env.sh
#
# ⚠️ WARNINGS SUPPRESSED:
#   - SC2034: result_var is dynamically assigned via nameref
#

read_choice() {
  local prompt="$1"
  local default="$2"

  # shellcheck disable=SC2034
  local -n result_var=$3 # result_var is assigned dynamically (intentional use of nameref)

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
