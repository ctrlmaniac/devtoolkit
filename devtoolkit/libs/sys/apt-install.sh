#!/usr/bin/env bash
# File: devtoolkit/libs/sys/_apt-install.sh
# Description: Internal helper to safely install packages using apt-get.

set -euo pipefail

apt_install() {
  local pkg="$1"

  if dpkg -s "$pkg" >/dev/null 2>&1; then
    printf "\n✅ %s is already installed. Skipping.\n" "$pkg"
    return 0
  fi

  printf "\n📦 Installing %s...\n" "$pkg"
  sudo apt-get update -y
  sudo apt-get install -y "$pkg"

  if dpkg -s "$pkg" >/dev/null 2>&1; then
    printf "✅ Successfully installed %s.\n" "$pkg"
  else
    printf "❌ Failed to install %s.\n" "$pkg" >&2
    return 1
  fi
}
