#!/usr/bin/env bash
# Prints a styled header block with emojis for better visual separation.

print_header() {
  # Usage: print_header "Your Title Here"
  local title="$1"
  local border_char="="
  local total_width=60
  local padding=4
  local title_length=${#title}
  local left_padding right_padding

  # Calculate padding for centering the title text
  if (( title_length + padding * 2 >= total_width )); then
    left_padding=2
    right_padding=2
  else
    left_padding=$(((total_width - title_length) / 2 - padding))
    right_padding=$((total_width - title_length - left_padding - padding * 2))
  fi

  # Print top border with emoji
  printf '\n%s\n' "$(printf '%*s' "$total_width" '' | tr ' ' "$border_char")"

  # Print the line with padding and title including emojis
  printf '%s%s%s%s%s\n' \
    "$(printf '%*s' "$padding" '')" \
    "$(printf '%*s' "$left_padding" '')" \
    "✨ $title ✨" \
    "$(printf '%*s' "$right_padding" '')" \
    "$(printf '%*s' "$padding" '')"

  # Print bottom border with emoji
  printf '%s\n\n' "$(printf '%*s' "$total_width" '' | tr ' ' "$border_char")"
}
