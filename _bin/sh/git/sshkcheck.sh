#!/usr/bin/env bash
#
# Script to check if a given SSH private key can successfully authenticate
# with an SSH server, typically GitHub.

# Attempt to source utility scripts
# Assuming this script is in devtoolkitsh/git/
# and check-install.sh is in devtoolkitsh/utils/.
# The shellcheck directive below tells shellcheck where to find it.
CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CHECK_INSTALL_SCRIPT_PATH="${CURRENT_SCRIPT_DIR}/../utils/check-install.sh" # Absolute path to the utility

if [ -f "${CHECK_INSTALL_SCRIPT_PATH}" ]; then
    # shellcheck source=../utils/check-install.sh
    # The path used in `source` is absolute at runtime. The directive helps shellcheck.
    source "${CHECK_INSTALL_SCRIPT_PATH}"
    
    # check_install exits if command not found
    check_install "ssh"
else
    echo "Warning: Utility script ${CHECK_INSTALL_SCRIPT_PATH} not found. Proceeding with manual check for ssh."
    if ! command -v ssh &> /dev/null; then
        echo "Error: ssh command not found. Please install OpenSSH."
        exit 1
    fi
fi

echo "=== SSH Key Authentication Check ==="
echo

# 1. Get the private key path from the user
default_ssh_dir="$HOME/.ssh"
echo "This script will test an SSH private key, typically against GitHub."
 
default_filename_to_suggest="github-$(whoami)-ed25519" # Filename part for suggestion
read -r -e -i "${default_filename_to_suggest}" \
    -p "Enter key filename (from ${default_ssh_dir}/) or full/relative path: " user_key_specifier
 
if [[ -z "$user_key_specifier" ]]; then
    echo "Error: Key input cannot be empty. Exiting."
    exit 1
fi
 
# Determine the actual key path
# If input contains '/', or starts with './', or starts with '../', treat as a path.
# Note: `read -e` expands `~` at the beginning of input if typed by the user.
if [[ "$user_key_specifier" == *"/"* ]] || \
   [[ "${user_key_specifier:0:2}" == "./" ]] || \
   [[ "${user_key_specifier:0:3}" == "../" ]]; then
    private_key_path="$user_key_specifier"
else
    # Assumed to be a filename within default_ssh_dir
    private_key_path="${default_ssh_dir}/${user_key_specifier}"
    echo # For better formatting
    echo "Assuming key '${user_key_specifier}' is in ${default_ssh_dir}/."
    echo "Using resolved path: ${private_key_path}"
fi
 
# Validate the resolved private_key_path
if [[ ! -f "$private_key_path" ]]; then
    echo "Error: Private key file not found at '${private_key_path}'. Exiting."
    exit 1
fi
 
if [[ ! -r "$private_key_path" ]]; then
    echo "Error: Private key file at '${private_key_path}' is not readable. Check permissions. Exiting."
    exit 1
fi
echo
# 2. Define the SSH target (defaulting to GitHub)
SSH_TARGET="git@github.com"

echo "Attempting to authenticate with '${SSH_TARGET}' using key:"
echo "  ${private_key_path}"
echo "Please wait..."
echo

# 3. Perform the SSH connection test
# Options:
# -i: Specify identity file
# -o IdentitiesOnly=yes: Use only specified identity file
# -o PasswordAuthentication=no: Disable password authentication
# -o KbdInteractiveAuthentication=no: Disable keyboard-interactive auth
# -o BatchMode=yes: Fail if passphrase needed and not in agent (non-interactive)
# -o StrictHostKeyChecking=accept-new: Accept new host keys automatically, fail if changed
# -T: Disable pseudo-tty allocation
# 2>&1: Redirect stderr to stdout to capture all output

ssh_output=$(ssh -i "${private_key_path}" \
    -o IdentitiesOnly=yes \
    -o PasswordAuthentication=no \
    -o KbdInteractiveAuthentication=no \
    -o BatchMode=yes \
    -o StrictHostKeyChecking=accept-new \
    -T "${SSH_TARGET}" 2>&1)

ssh_exit_code=$?

echo "--- Test Result ---"
# GitHub's successful test exits with 1 and a specific message.
if [[ $ssh_exit_code -eq 1 ]] && [[ "$ssh_output" == *"You've successfully authenticated"* ]]; then
    echo "✅ SUCCESS: Authentication with '${SSH_TARGET}' was successful using this key."
    echo "Server response:"
    echo "${ssh_output}"
elif [[ $ssh_exit_code -eq 255 ]] && [[ "$ssh_output" == *"Permission denied"* ]]; then
    echo "❌ FAILURE: Authentication with '${SSH_TARGET}' failed. Permission denied by server."
    echo "Server response:"
    echo "${ssh_output}"
    echo
    echo "Common reasons for failure:"
    echo "  - The corresponding public key is not added to your GitHub account."
    echo "  - The private key file is incorrect or corrupted."
    echo "  - If the key is passphrase-protected, it must be added to your ssh-agent (e.g., 'ssh-add \"${private_key_path}\"')."
else
    echo "⚠️ UNCERTAIN/ERROR: The SSH command exited with code ${ssh_exit_code}."
    echo "Server response (if any):"
    echo "${ssh_output}"
    echo
    echo "This could be due to various reasons, including network issues, server problems,"
    echo "or if a passphrase-protected key is not managed by ssh-agent (BatchMode was used)."
    echo "If the key has a passphrase, ensure it's added to your ssh-agent: 'ssh-add \"${private_key_path}\"'"
fi
echo

exit 0