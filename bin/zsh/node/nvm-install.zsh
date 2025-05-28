#!/usr/bin/env zsh
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

setopt errexit nounset pipefail

# Check if script is sourced or run directly
# In Zsh, if $0 (command used) is the same as the script's path/name, it's likely executed directly.
if [[ $0 == ${(%):-%x} || $0 == ${(%):-%N} ]]; then
  echo "⚠️ Warning: This script is not sourced. Some changes may not affect your current shell."
  echo "➡️ Please run 'source ${(%):-%x}' to properly apply node version changes."
  echo # Add a newline for better spacing after the warning
fi

# Check if nvm is installed
echo
if ! command -v nvm &>/dev/null; then
  echo "⬇️ Installing NVM (Node Version Manager)..."
  # Execute the downloaded script with zsh
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | zsh
  echo # Add a newline for better spacing after installation message

  # Load nvm
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  echo "✅ NVM is already installed."
fi
echo

# Fetch versions list
echo "🔍 Fetching available Node.js versions..."
nvm_ls_remote=$(nvm ls-remote)

# Extract versions: latest non-LTS and last three LTS versions
latest_non_lts=$(echo "$nvm_ls_remote" | grep -v 'Latest LTS:' | grep -v '->' | grep -v 'lts/' | tail -1 | awk '{print $1}')
lts_versions=($(echo "$nvm_ls_remote" | grep 'Latest LTS:' | head -3 | awk '{print $3}' | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+'))

echo -e "\n📋 Available Node.js versions to install:"
echo "  0) $latest_non_lts (latest non-LTS)"
# In Zsh, array indices are 1-based. ${!lts_versions[@]} gives 1, 2, 3...
for i in ${!lts_versions[@]}; do
  echo "  $i) ${lts_versions[$i]} (LTS)" # Use $i directly as it's already 1, 2, 3...
done
echo

echo -e "\n✍️ Enter the versions you want to install, separated by commas or spaces (e.g. v20.10.0,v18.18.2):"
read -r versions_input
echo

# Normalize input into array (split by comma or space)
# Zsh way to split string by comma or space into an array
versions_input_no_commas=${versions_input//,/ } # Replace commas with spaces
versions_array=(${(f)versions_input_no_commas})  # Split by IFS (space, tab, newline)

# Validate versions
valid_versions=()
all_versions=("$latest_non_lts" "${lts_versions[@]}")

for ver in "${versions_array[@]}"; do
  # Zsh way to check if an element exists in an array
  if (( ${all_versions[(Ie)$ver]} )); then
    valid_versions+=("$ver")
  else
    echo "⚠️ Invalid version specified and skipped: $ver"
  fi
done

if [ ${#valid_versions[@]} -eq 0 ]; then
  echo
  echo "❌ No valid versions selected. Exiting."
  exit 1
fi
echo

# Install versions
for version in "${valid_versions[@]}"; do
  echo "⬇️ Installing Node.js $version..."
  nvm install "$version"
  echo # Add a newline for better spacing after installation message
done
echo

# Ask user to choose default version
echo -e "\n📌 Installed versions: ${valid_versions[*]}"
echo "✍️ Enter which installed version you want to set as default:"
read -r default_version
echo

# Zsh way to check if an element exists in an array
if (( ${valid_versions[(Ie)$default_version]} )); then
  echo "⭐ Setting $default_version as the default Node.js version..."
  nvm alias default "$default_version"
  nvm use "$default_version"
else
  echo "⚠️ Invalid default version specified: $default_version. Skipping setting default."
fi
echo
