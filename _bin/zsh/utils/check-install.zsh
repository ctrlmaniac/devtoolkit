#!/usr/bin/env zsh

# Usage: check_install <command_name> <package_name>
# Checks if a command exists. If not, asks user to install the given package.

setopt errexit nounset pipefail

check_install() {
  local cmd=$1
  local pkg=$2

  if ! command -v "$cmd" &>/dev/null; then
    echo -e "❌ '$cmd' is not installed on your system.\n"
    echo
    read -r -p "👉 Would you like to install $pkg now? (y/n) " install_pkg
    case "$install_pkg" in
      y|Y )
        echo -e "\n🔧 Installing $pkg...\n"
        sudo apt update && sudo apt install -y "$pkg"
        if ! command -v "$cmd" &>/dev/null; then
          echo -e "\n❗ Installation failed. Please install $pkg manually and rerun this script.\n"
          exit 1
        fi
        ;;
      * )
        echo -e "\n🚫 '$cmd' is required. Aborting setup.\n"
        exit 1
        ;;
    esac
    echo
  else
    echo -e "✅ '$cmd' is already installed. Continuing...\n"
  fi
  echo
}
