#!/usr/bin/env zsh

# Script to create a basic .wslconfig file on the Windows filesystem from within WSL.
# This script is intended to create the .wslconfig file in the Windows user's
# profile directory, e.g., /mnt/c/Users/<YourWindowsUser>/.wslconfig
#
# It now automatically infers the Windows user's profile directory using wslvar.

setopt errexit nounset pipefail

# Attempt to get the Windows USERPROFILE path using wslvar
WINDOWS_USERPROFILE_WSL_PATH=$(wslvar USERPROFILE 2>/dev/null)

if [ -z "$WINDOWS_USERPROFILE_WSL_PATH" ]; then
  echo "❌ Error: Could not retrieve Windows USERPROFILE path using wslvar." >&2
  echo "Please ensure wslvar is available and working correctly in your WSL distribution." >&2
  echo "If wslvar is not available, you might need to update WSL or your distribution." >&2
  echo
  echo "As a fallback, you can manually specify the target path as an argument:" >&2
  echo "Usage: $0 /mnt/c/Users/<YourWindowsUser>/.wslconfig" >&2
  exit 1
fi

# Construct the target path for .wslconfig
TARGET_WSLCONFIG_PATH="${WINDOWS_USERPROFILE_WSL_PATH}/.wslconfig"
WINDOWS_USERNAME=$(wslvar USERNAME 2>/dev/null || echo "unknown (wslvar USERNAME failed)")

# Basic content for .wslconfig, matching the example provided.
WSLCONFIG_CONTENT="[wsl2]
memory=8GB   # Or however much you want to allocate, e.g., half your system RAM
processors=4 # Number of logical processors to assign
# swap=2GB
# localhostForwarding=true"

echo
echo "Attempting to create a basic .wslconfig for Windows user: '$WINDOWS_USERNAME'"
echo "Target path: $TARGET_WSLCONFIG_PATH"
echo

# Check if the parent directory of the target path is writable from WSL.
# This is a basic check; actual write permission depends on Windows NTFS permissions.
PARENT_DIR=$(dirname "$TARGET_WSLCONFIG_PATH")
if [ ! -w "$PARENT_DIR" ]; then
    echo "⚠️ Warning: The directory '$PARENT_DIR' might not be writable from WSL." >&2
    echo "Attempting to write the file anyway..." >&2
    echo
fi

# Write the content to the file.
# Using printf for reliable output. Overwrites the file if it exists.
if printf "%s\n" "$WSLCONFIG_CONTENT" > "$TARGET_WSLCONFIG_PATH"; then
  echo "✅ Successfully created basic .wslconfig at '$TARGET_WSLCONFIG_PATH' with the following content:"
  echo
  echo "--------------------------------------------------"
  cat "$TARGET_WSLCONFIG_PATH"
  echo "--------------------------------------------------"
  echo
  echo "📢 IMPORTANT: For these changes to take effect on Windows, WSL must be shut down."
  echo "From PowerShell or CMD on Windows, run: wsl --shutdown"
  echo "Then, restart your WSL distribution."
else
  echo "❌ Error: Failed to write to '$TARGET_WSLCONFIG_PATH'." >&2
  echo "Please check the path, permissions on the Windows side, and ensure the parent directory exists." >&2
  exit 1
fi
echo
exit 0
