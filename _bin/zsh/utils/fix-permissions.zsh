#!/usr/bin/env zsh
#
# Script to set standardized permissions for a development toolkit directory.
#
# This script will:
# 1. Change ownership of all contents in the target directory to the current user.
# 2. Set directory permissions to 'rwxr-xr-x' (mode 755) 📂.
# 3. Set regular file permissions to 'rw-r--r--' (mode 644) 📄.
# 4. Make '*.sh' files executable with 'rwxr-xr-x' (mode 755) 📜.

setopt errexit # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
# Default target directory if no argument is provided.
DEFAULT_TARGET_DIR="$HOME/webnodex/devtoolkitsh"
# --- End Configuration ---

TARGET_DIR="${1:-$DEFAULT_TARGET_DIR}"

# Function to attempt to get absolute path for messages
get_abs_path() {
    local target_path="$1"
    if command -v realpath &> /dev/null; then
        realpath -m "$target_path" # -m: no error if path doesn't exist, just normalize
    elif (cd "$(dirname "$target_path")" &>/dev/null && echo "$(cd "$(dirname "$target_path")" && pwd)/$(basename "$target_path")"); then
        # More robust way to get absolute path if realpath is not available
        echo "$(cd "$(dirname "$target_path")" && pwd)/$(basename "$target_path")"
    else
        echo "$target_path" # Fallback
    fi
}

# Safety check for target directory
is_safe_target() {
    local dir_to_check="$1"
    local abs_dir_to_check
    abs_dir_to_check=$(get_abs_path "$dir_to_check")

    # Allow if it's under user's home directory
    if [[ "$abs_dir_to_check" == "$HOME"* ]]; then
        return 0 # Safe if under home
    fi

    # Prevent running on common critical system paths if not under HOME
    local critical_paths=("/" "/bin" "/boot" "/dev" "/etc" "/lib" "/lib64" "/opt" "/proc" "/root" "/run" "/sbin" "/srv" "/sys" "/tmp" "/usr" "/var")
    for path in "${critical_paths[@]}"; do
        # Check for exact match or if it's a parent/child of a critical path
        if [[ "$abs_dir_to_check" == "$path" || "$abs_dir_to_check/" == "$path/"* || "$path/" == "$abs_dir_to_check/"* ]]; then
            echo "❌ ERROR: Target directory '$abs_dir_to_check' appears to be a critical system path or related to one." >&2
            echo "🛡️ This script is intended for user project directories (ideally within your home directory)." >&2
            echo "Aborting for safety." >&2
            return 1 # Not safe
        fi
    done
    return 0 # Considered safe if not a known critical path (e.g. /mnt/myproject)
}

# Validate target directory
if [ -z "$TARGET_DIR" ]; then
    echo "❌ Error: Target directory path is empty."
    echo
    exit 1
fi
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Target directory '$TARGET_DIR' not found or is not a directory."
    echo "Please ensure the path is correct or create the directory."
    echo
    exit 1
fi

ABS_TARGET_DIR=$(get_abs_path "$TARGET_DIR")

if ! is_safe_target "$ABS_TARGET_DIR"; then
    echo
    exit 1
fi
echo

echo "🛠️ --- Permission Adjustment Script --- 🛠️"
echo "This script will adjust ownership and permissions for the directory:"
echo "  $ABS_TARGET_DIR"
echo
echo "📋 Operations to be performed:"
echo "1. 👤 Change ownership of all contents to YOU ($USER)."
echo "   (This step may require sudo password if files are owned by another user)."
echo "2. 📂 Set directory permissions to 'rwxr-xr-x' (mode 755)."
echo "3. 📄 Set regular file permissions to 'rw-r--r--' (mode 644)."
echo "4. 📜 Make '*.sh' files executable with 'rwxr-xr-x' (mode 755)."
echo
echo "⚠️ WARNING: Ensure '$ABS_TARGET_DIR' is the correct project directory."
echo "Applying this to the wrong directory could have unintended consequences."
echo
read -r -p "Are you absolutely sure you want to proceed? (yes/N): " confirm
if [[ "$confirm" != "yes" ]]; then # Require explicit 'yes'
    echo "Operation cancelled by user."
    echo
    exit 0
fi
echo
echo "🚀 Proceeding..."
echo # Extra newline for spacing

CURRENT_USER=$(id -un)
CURRENT_GROUP=$(id -gn "$CURRENT_USER")

echo "🔢 [Step 1/4] Changing ownership of all contents in '$ABS_TARGET_DIR' to $CURRENT_USER:$CURRENT_GROUP..."
if sudo chown -R "$CURRENT_USER":"$CURRENT_GROUP" "$ABS_TARGET_DIR"; then
    echo "✅ Ownership changed successfully."
else
    echo "❌ ERROR: Failed to change ownership. This is a critical step." >&2
    echo "Please ensure you have sudo privileges and that the target path is valid." >&2
    echo
    exit 1
fi
echo # Extra newline for spacing

echo "🔢 [Step 2/4] Setting directory permissions to 755 (rwxr-xr-x)..."
find "$ABS_TARGET_DIR" -type d -exec chmod 755 {} +
echo "✅ Directory permissions set."
echo # Extra newline for spacing

echo "🔢 [Step 3/4] Setting regular file permissions to 644 (rw-r--r--)..."
find "$ABS_TARGET_DIR" -type f -exec chmod 644 {} +
echo "✅ Regular file permissions set."
echo # Extra newline for spacing

echo "🔢 [Step 4/4] Making .sh files executable (755, rwxr-xr-x)..."
find "$ABS_TARGET_DIR" -type f -name "*.sh" -exec chmod 755 {} +
echo "✅ .sh files made executable."
echo # Extra newline for spacing

echo "🎉 --- Permissions adjustment complete for '$ABS_TARGET_DIR' --- 🎉"
echo "Please verify the permissions to ensure they meet your expectations."
echo

exit 0
