#!/usr/bin/env bash
# devtoolkit/libs/_print-header.sh
#
# Utility to print a styled header line with emojis
#
# This function prints a visually distinct header line with sparkle
# emojis around the given title, padded with spaces and preceded/followed
# by blank lines for separation.
#
# USAGE:
#   source devtoolkit/libs/_print-header.sh
#   print_header "Your Title Here"
#
# PARAMETERS:
#   $1 - The title string to display in the header
#
# EXAMPLE:
#   print_header "Starting Installation"
#
# OUTPUT:
#   Prints output like:
#
#   (blank line)
#       ✨ Starting Installation ✨
#   (blank line)
#
print_header() {
  local title="$1"
  local padding=4

  printf '\n' # Blank line before

  # Print the title line with emojis and padding
  printf '%*s%s%s%s\n' \
    "$padding" '' \
    "✨ " \
    "$title" \
    " ✨"

  printf '\n' # Blank line after
}
