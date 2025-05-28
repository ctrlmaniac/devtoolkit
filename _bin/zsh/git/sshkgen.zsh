#!/usr/bin/env zsh
#
# Script to generate an SSH key, primarily for GitHub access.
#
# This script guides the user through generating an Ed25519 SSH key,
# provides the public key, and instructions for adding it to GitHub.
# It also offers to add the key to ssh-agent and copy the public key
# to the clipboard.

setopt errexit nounset pipefail

# Attempt to source utility scripts
# Assuming this script is in devtoolkitsh/git/
# and check-install.sh is in devtoolkitsh/utils/.
# The shellcheck directive below tells shellcheck where to find it.
CURRENT_SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" &>/dev/null && pwd)"
CHECK_INSTALL_SCRIPT_PATH="${CURRENT_SCRIPT_DIR}/../utils/check-install.sh" # Absolute path to the utility

echo
if [ -f "${CHECK_INSTALL_SCRIPT_PATH}" ]; then
    # shellcheck source=../utils/check-install.sh
    # The path used in `source` is absolute at runtime. The directive helps shellcheck.
    source "${CHECK_INSTALL_SCRIPT_PATH}"

    # check_install exits if command not found
    check_install "ssh-keygen"
else
    echo "Warning: Utility script ${CHECK_INSTALL_SCRIPT_PATH} not found. Proceeding with manual check for ssh-keygen."
    if ! command -v ssh-keygen &> /dev/null; then
        echo "Error: ssh-keygen command not found. Please install OpenSSH."
        exit 1
    fi
fi

echo -e "\n🔑 === SSH Key Generation for GitHub === 🔑"
echo # Extra newline for spacing

# 1. Get email address
echo "This script will help you generate an SSH key to use with GitHub."
read -r -p "Enter your GitHub email address (this will be a comment in your key): " email
echo
if [[ -z "$email" ]]; then
    echo "❌ Error: Email address cannot be empty. Exiting."
    exit 1
fi
echo # Extra newline for spacing

# 2. Get key filename
default_key_name="github-$(whoami)-ed25519"
echo
read -r -p "Enter a name for your SSH key file (e.g., my_github_key, default: ${default_key_name}): " key_name
key_name="${key_name:-$default_key_name}"

if [[ "$key_name" == *"/"* ]] || [[ "$key_name" == *".."* ]]; then
    echo "Error: Invalid key name. It should not contain path separators (/) or '..'. Exiting."
    exit 1
fi

ssh_dir="$HOME/.ssh"
key_filepath="${ssh_dir}/${key_name}"
echo # Extra newline for spacing

# 3. Ensure ~/.ssh directory exists and has correct permissions
if [ ! -d "$ssh_dir" ]; then
    echo "The SSH directory (${ssh_dir}) does not exist."
    echo "Creating it now with secure permissions (700)..."
    if ! mkdir -p "$ssh_dir"; then
        echo "Error: Could not create directory ${ssh_dir}."
        echo "Please check permissions or create it manually: 'mkdir -p ${ssh_dir} && chmod 700 ${ssh_dir}'" # No emoji, part of error message
        exit 1
    fi
    if ! chmod 700 "$ssh_dir"; then
        echo "Error: Could not set permissions for ${ssh_dir} to 700."
        echo "Please set them manually: 'chmod 700 ${ssh_dir}'" # No emoji, part of error message
        exit 1
    fi
    echo "${ssh_dir} created and permissions set to 700."
else
    echo "SSH directory (${ssh_dir}) already exists."
    echo "Ensuring its permissions are secure (700)..."
    if ! chmod 700 "$ssh_dir"; then
        echo "⚠️ Warning: Could not ensure permissions for ${ssh_dir} are 700."
        echo "Please check and set them manually if needed: 'chmod 700 ${ssh_dir}'"
        echo "Insecure permissions can cause SSH to ignore keys."
    else
        echo "Permissions for ${ssh_dir} verified/set to 700."
    fi
fi
echo
echo # Extra newline for spacing

# 4. Check for existing key and overwrite confirmation
if [ -f "${key_filepath}" ] || [ -f "${key_filepath}.pub" ]; then
    echo "⚠️ Warning: Key file '${key_filepath}' or '${key_filepath}.pub' already exists."
    read -r -p "Do you want to overwrite? (y/N): " overwrite
    echo
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Overwriting existing key files."
        rm -f "${key_filepath}" "${key_filepath}.pub"
    else
        echo "Aborted. Key generation cancelled to prevent overwriting."
        exit 1
    fi
fi
echo # Extra newline for spacing

# 5. Get passphrase
echo
read -r -s -p "Enter a passphrase for your new SSH key (empty for no passphrase): " passphrase
echo # Move to a new line after passphrase input
read -r -s -p "Confirm passphrase: " passphrase_confirm
echo # Move to a new line

if [[ "$passphrase" != "$passphrase_confirm" ]]; then
    echo "❌ Error: Passphrases do not match. Exiting."
    exit 1
fi
echo # Extra newline for spacing

# 6. Generate the SSH key
echo
echo "Generating Ed25519 SSH key: ${key_filepath}"
if ssh-keygen -t ed25519 -C "$email" -f "$key_filepath" -N "$passphrase"; then
    echo "SSH key pair generated successfully!"
    echo "Private key: ${key_filepath}"
    echo "Public key:  ${key_filepath}.pub"
else
    echo "❌ Error: Failed to generate SSH key. Please check any messages above."
    exit 1
fi
echo # Extra newline for spacing

# 7. Display public key and instructions for GitHub
echo
echo "Your public SSH key is:"
echo "--------------------------------------------------------------------------------"
cat "${key_filepath}.pub"
echo "--------------------------------------------------------------------------------"
echo # Extra newline for spacing
echo "Next steps to add this key to your GitHub account:"
echo "1. Copy the entire public key above (it starts with 'ssh-ed25519...' and ends with your email)."
echo "2. Go to GitHub in your browser: https://github.com/settings/keys"
echo "3. Click on 'New SSH key'."
echo "4. Give it a descriptive 'Title' (e.g., 'My Work Laptop - $(hostname)')."
echo "5. Paste the copied public key into the 'Key' field."
echo "6. Click 'Add SSH key'."
echo # Extra newline for spacing

# 8. Optionally add to ssh-agent
read -r -p "Do you want to attempt to add this new key to the ssh-agent? (y/N): " add_to_agent
echo
if [[ "$add_to_agent" =~ ^[Yy]$ ]]; then
    if ! command -v ssh-add &> /dev/null; then
        echo "ssh-add command not found. Cannot add key to agent automatically."
        echo "You can do it manually later if ssh-agent is running: ssh-add ${key_filepath}"
    else
        echo "Attempting to add key to ssh-agent..."
        # Ensure ssh-agent is running (this starts a new one if none is found for the current session)
        # For the key to be available in the current shell, the user might need to run this eval themselves.
        # However, ssh-add will try to connect to an existing agent.
        if [ -z "$SSH_AUTH_SOCK" ] ; then
            echo "SSH_AUTH_SOCK is not set. You might need to start ssh-agent in your shell:"
            echo "  eval \"\$(ssh-agent -s)\"" # No emoji, part of instruction
            echo "Then run: ssh-add ${key_filepath}" # No emoji, part of instruction
        fi

        if ssh-add "${key_filepath}"; then
            echo "Key added to ssh-agent successfully."
            if [ -n "$passphrase" ]; then
                 echo "You were likely prompted for your passphrase."
            fi
        else
            echo "Failed to add key to ssh-agent."
            echo "This could be because the ssh-agent is not running or accessible."
            echo "To start an agent and add the key manually in your current shell:" # No emoji, part of instruction
            echo "  eval \"\$(ssh-agent -s)\"" # No emoji, part of instruction
            echo "  ssh-add ${key_filepath}" # No emoji, part of instruction
        fi
    fi
fi
echo # Extra newline for spacing

# 9. Optionally copy public key to clipboard
copy_command=""
if command -v pbcopy &> /dev/null; then # macOS
    copy_command="pbcopy"
elif command -v xclip &> /dev/null; then # Linux with X11
    copy_command="xclip -selection clipboard -in"
elif command -v xsel &> /dev/null; then # Linux with X11 (alternative)
    copy_command="xsel --clipboard --input"
elif command -v clip.exe &> /dev/null; then # Windows (WSL)
    copy_command="clip.exe"
fi

if [ -n "$copy_command" ]; then
    read -r -p "Do you want to try copying the public key to your clipboard? (y/N): " copy_to_clipboard
    echo
    if [[ "$copy_to_clipboard" =~ ^[Yy]$ ]]; then
        if $copy_command < "${key_filepath}.pub"; then
            echo "Public key copied to clipboard."
        else
            echo "Failed to copy public key to clipboard. Please copy it manually from the output above."
        fi
    fi
else
    echo "No common clipboard utility (pbcopy, xclip, xsel, clip.exe) found."
    echo "Please copy the public key manually from the output above."
fi
echo # Extra newline for spacing

echo "✅ Script finished. Remember to add the public key to your GitHub account if you haven't already."

exit 0
