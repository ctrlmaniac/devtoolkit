#!/usr/bin/env bash
# node/nvm-install.sh
#
# USAGE:
#   source node/nvm-install.sh
#
# DESCRIPTION:
#   Installs NVM (Node Version Manager) if not installed,
#   lists available Node.js versions (latest non-LTS and last three LTS versions),
#   prompts the user to select one or more versions to install,
#   and then sets a selected version as the default.
#
#   ⚠️ IMPORTANT: To allow version switching to affect your current shell,
#   you must *source* the script instead of running it directly.
#   Use:
#
#     source node/nvm-install.sh
#
#   Running it directly will install the versions but won't switch the current shell's node version.

set -euo pipefail

# Check if script is sourced or run directly
(is_sourced() {
  [[ "${BASH_SOURCE[0]}" != "$0" ]]
}) || {
  echo "⚠️ Warning: This script is not sourced. Some changes may not affect your current shell."
  echo "➡️ Please run 'source ${BASH_SOURCE[0]}' to properly apply node version changes."
}

# Check if nvm is installed
if ! command -v nvm &>/dev/null; then
  echo "⬇️ Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  # Load nvm
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  echo "✅ NVM is already installed."
fi

# Fetch versions list
echo "🔍 Fetching available Node.js versions..."
nvm_ls_remote=$(nvm ls-remote)

# Extract versions: latest non-LTS and last three LTS versions
latest_non_lts=$(echo "$nvm_ls_remote" | grep -v 'Latest LTS:' | grep -v '->' | grep -v 'lts/' | tail -1 | awk '{print $1}')
lts_versions=($(echo "$nvm_ls_remote" | grep 'Latest LTS:' | head -3 | awk '{print $3}' | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+'))

echo -e "\n📋 Available Node.js versions to install:"
echo "  0) $latest_non_lts (latest non-LTS)"
for i in "${!lts_versions[@]}"; do
  echo "  $((i+1))) ${lts_versions[$i]} (LTS)"
done

echo -e "\n✍️ Enter the versions you want to install, separated by commas or spaces (e.g. v20.10.0,v18.18.2):"
read -r versions_input

# Normalize input into array (split by comma or space)
IFS=', ' read -ra versions_array <<< "$versions_input"

# Validate versions
valid_versions=()
all_versions=("$latest_non_lts" "${lts_versions[@]}")

for ver in "${versions_array[@]}"; do
  if [[ " ${all_versions[*]} " == *" $ver "* ]]; then
    valid_versions+=("$ver")
  else
    echo "⚠️ Invalid version specified and skipped: $ver"
  fi
done

if [ ${#valid_versions[@]} -eq 0 ]; then
  echo "❌ No valid versions selected. Exiting."
  exit 1
fi

# Install versions
for version in "${valid_versions[@]}"; do
  echo "⬇️ Installing Node.js $version..."
  nvm install "$version"
done

# Ask user to choose default version
echo -e "\n📌 Installed versions: ${valid_versions[*]}"
echo "✍️ Enter which installed version you want to set as default:"
read -r default_version

if [[ " ${valid_versions[*]} " == *" $default_version "* ]]; then
  echo "⭐ Setting $default_version as the default Node.js version..."
  nvm alias default "$default_version"
  nvm use "$default_version"
else
  echo "⚠️ Invalid default version specified: $default_version. Skipping setting default."
fi
