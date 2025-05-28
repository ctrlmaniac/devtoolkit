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

setopt errexit nounset pipefail

# Supported package managers
pms=("pnpm" "yarn")

echo
echo "📦 Available package managers to install:"
# In Zsh, array indices are 1-based. ${!pms[@]} gives 1, 2...
for i in ${!pms[@]}; do
  echo "  $i. ${pms[$i]}" # Use $i directly
done
echo

echo -e "\n✍️  Enter the number(s) of the package manager(s) you want to install, separated by commas (e.g. 1,2):"
read -r selected_pm_numbers
echo

# Zsh way to split string by comma into an array
selected_indices=(${(s:,:)selected_pm_numbers})

for index in "${selected_indices[@]}"; do
  index_trimmed=$(echo "$index" | xargs) # xargs for trimming whitespace
  if [[ "$index_trimmed" =~ ^[0-9]+$ ]] && ((index_trimmed >= 1 && index_trimmed <= ${#pms[@]})); then
    # Zsh arrays are 1-indexed. If user enters 1, index_trimmed is 1, so pms[1] is correct.
    pm=${pms[$index_trimmed]}
    echo "⬇️  Installing $pm..."
    if [ "$pm" == "pnpm" ]; then
      curl -fsSL https://get.pnpm.io/install.sh | zsh - # Use zsh to execute
    elif [ "$pm" == "yarn" ]; then
      corepack disable 2>/dev/null || true
      npm install -g yarn
    fi
    echo "✅ Installed $pm."
    echo
  else
    echo "⚠️  Invalid selection: '$index_trimmed'. Skipping."
    echo
  fi
done
echo

# Offer aliasing npm/npx
echo -e "\n🔁 Would you like to alias 'npm' and 'npx' to use your selected PM? (y/N)"
read -r confirm_alias
echo
if [[ "$confirm_alias" =~ ^[Yy]$ ]]; then
  echo -e "⚠️  This requires sourcing the script or adding aliases to your shell profile."
  echo -e "📄 To do it manually, add these lines to your ~/.bashrc or ~/.zshrc (depending on your shell):"
  echo -e "\n  alias npm='pnpm'"
  echo -e "  alias npx='pnpm dlx'"
  echo -e "\n💡 If you chose yarn, replace with 'yarn' accordingly."
  echo

  # Check if running via source
  # In Zsh, if $0 (command used) is the same as the script's path/name, it's likely executed directly.
  if [[ $0 == ${(%):-%x} || $0 == ${(%):-%N} ]]; then
    echo "❌ This script was not sourced. Aliases will not persist."
    echo "➡️  Please run 'source ${(%):-%x}' or add aliases manually."
  else
    echo "📝 Applying aliases for current shell session..."
    # Zsh way to check if an element exists in an array
    if (( ${selected_indices[(Ie)1]} )); then # Check if '1' (for pnpm) was selected
      alias npm='pnpm'
      alias npx='pnpm dlx'
      echo "✅ Aliases for pnpm set in current shell."
    elif (( ${selected_indices[(Ie)2]} )); then # Check if '2' (for yarn) was selected
      alias npm='yarn'
      alias npx='yarn dlx'
      echo "✅ Aliases for yarn set in current shell."
    else
      echo "🤔 No primary PM selected for aliasing or multiple selected. Please set aliases manually if needed."
    fi
    echo "💡 Add them to your shell profile (e.g. ~/.zshrc) to make them permanent."
  fi
else
  echo "🚫 Skipping aliasing. You can always add them manually later."
fi
echo
