#!/usr/bin/env bash
# Usage and help text for SSH key generation and checking scripts

print_usage() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Check if a given SSH private key can authenticate with GitHub.

Options:
  -h, --help      Show this help message and exit

This script prompts for an SSH private key path and attempts to authenticate with GitHub
using that key, printing the success or failure result.

Examples:
  $(basename "$0")
EOF
}
