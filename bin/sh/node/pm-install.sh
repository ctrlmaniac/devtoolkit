#!/usr/bin/env bash
# Install a Node.js package manager (pnpm, yarn) and optionally alias npm/npx

# USAGE:
#   source node/pm-install.sh
#
# DESCRIPTION:
#   This script allows you to install one or more Node.js package managers (pnpm or yarn), and
#   optionally alias 'npm' and 'npx' to the selected package manager. This is helpful for
#   monorepo setups or enforcing a consistent developer toolchain.
#
#   ⚠️ IMPORTANT: To allow aliasing to take effect in your current shell session,
#   you must *source* the script rather than run it directly. Use:
#
#     source node/pm-install.sh
#
#   If you run it directly, aliases will not persist and you'll have to add them
#   manually to your shell profile (e.g. ~/.bashrc or ~/.zshrc).

set -euo pipefail

# Supported package managers
pms=("pnpm" "yarn")

echo "📦 Available package managers to install:"
for i in "${!pms[@]}"; do
  echo "  $((i + 1)). ${pms[$i]}"
done

echo -e "\n✍️  Enter the number(s) of the package manager(s) you want to install, separated by commas (e.g. 1,2):"
read -r selected_pm_numbers

IFS=',' read -ra selected_indices <<< "$selected_pm_numbers"

for index in "${selected_indices[@]}"; do
  index_trimmed=$(echo "$index" | xargs)
  if [[ "$index_trimmed" =~ ^[0-9]+$ ]] && ((index_trimmed >= 1 && index_trimmed <= ${#pms[@]})); then
    pm=${pms[$((index_trimmed - 1))]}
    echo "⬇️  Installing $pm..."
    if [ "$pm" == "pnpm" ]; then
      curl -fsSL https://get.pnpm.io/install.sh | sh -
    elif [ "$pm" == "yarn" ]; then
      corepack disable 2>/dev/null || true
      npm install -g yarn
    fi
    echo "✅ Installed $pm."
  else
    echo "⚠️  Invalid selection: '$index_trimmed'. Skipping."
  fi

done

# Offer aliasing npm/npx
echo -e "\n🔁 Would you like to alias 'npm' and 'npx' to use your selected PM? (y/N)"
read -r confirm_alias
if [[ "$confirm_alias" =~ ^[Yy]$ ]]; then
  echo -e "⚠️  This requires sourcing the script or adding aliases to your shell profile."
  echo -e "📄 To do it manually, add these lines to your ~/.bashrc or ~/.zshrc (depending on your shell):"
  echo -e "\n  alias npm='pnpm'"
  echo -e "  alias npx='pnpm dlx'"
  echo -e "\n💡 If you chose yarn, replace with 'yarn' accordingly."

  # Check if running via source
  if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "❌ This script was not sourced. Aliases will not persist."
    echo "➡️  Please run 'source $0' or add aliases manually."
  else
    echo "📝 Applying aliases for current shell session..."
    # For now, assume pnpm if selected
    if [[ "${selected_indices[*]}" == *"1"* ]]; then
      alias npm='pnpm'
      alias npx='pnpm dlx'
    elif [[ "${selected_indices[*]}" == *"2"* ]]; then
      alias npm='yarn'
      alias npx='yarn dlx'
    fi
    echo "✅ Aliases set in current shell. Add them to your shell profile to make them permanent."
  fi
else
  echo "🚫 Skipping aliasing. You can always add them manually later."
fi
