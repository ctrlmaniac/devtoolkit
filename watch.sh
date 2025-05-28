#!/bin/bash

# Script to intelligently watch for file changes.
# Attempts to use chokidar-cli if Node.js and a package manager are available.
# Falls back to a native polling mechanism otherwise.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
WORKSPACE_ROOT="." # Assuming script is run from workspace root
ENV_FILE="${WORKSPACE_ROOT}/.env"
NVMRC_FILE="${WORKSPACE_ROOT}/.nvmrc"
POLL_INTERVAL=3 # Seconds for polling fallback

# --- Helper Functions ---

log_info() {
    echo "INFO: $1"
}

log_warn() {
    echo "WARN: $1"
}

log_error() {
    echo "ERROR: $1" >&2
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

source_env_if_exists() {
    if [ -f "$ENV_FILE" ]; then
        log_info "Sourcing environment variables from $ENV_FILE"
        set -a # Automatically export all variables subsequently defined or modified
        # shellcheck source=/dev/null
        . "$ENV_FILE" # Use . (dot) for POSIX compatibility to source
        set +a
    fi
}

# --- Chokidar Setup ---
setup_chokidar_environment() {
    log_info "Attempting to set up chokidar-cli environment..."

    if ! check_command node; then
        log_warn "Node.js is not installed or not in PATH. Cannot set up chokidar-cli."
        return 1
    fi
    local node_version
    node_version=$(node -v)
    log_info "Node.js found: $node_version"

    local pm_choice
    local pm_install_cmd
    local available_pms=()

    if check_command npm; then available_pms+=("npm"); fi
    if check_command yarn; then available_pms+=("yarn"); fi
    if check_command pnpm; then available_pms+=("pnpm"); fi

    if [ ${#available_pms[@]} -eq 0 ]; then
        log_warn "No supported package manager (npm, yarn, pnpm) found. Cannot install chokidar-cli."
        return 1
    fi

    echo # Newline for readability
    log_info "Please choose a package manager to install chokidar-cli globally:"
    PS3="Enter number for package manager: "
    select opt in "${available_pms[@]}"; do
        if [[ -n "$opt" ]]; then
            pm_choice="$opt"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
    echo # Newline for readability

    log_info "Using $pm_choice to install chokidar-cli globally..."
    case "$pm_choice" in
        npm) pm_install_cmd="npm install -g chokidar-cli" ;;
        yarn) pm_install_cmd="yarn global add chokidar-cli" ;;
        pnpm) pm_install_cmd="pnpm add -g chokidar-cli" ;;
        *) log_error "Internal error: Unknown package manager '$pm_choice'."; return 1 ;;
    esac

    if $pm_install_cmd; then
        log_info "chokidar-cli installed successfully via $pm_choice."

        # Create .nvmrc
        echo "$node_version" > "$NVMRC_FILE"
        log_info "Created $NVMRC_FILE with Node version $node_version"

        # Create .env
        echo "PM=$pm_choice" > "$ENV_FILE"
        # This is the command chokidar will execute. Quotes are important.
        local chokidar_inner_cmd="find . -type f -name '*.sh' -exec ls -l {} + && find . -type f -name '*.sh' -exec chmod +x {} +"
        # This is the command this script will run using bash -c
        local chokidar_full_cmd="chokidar . --initial -c \"$chokidar_inner_cmd\""
        echo "CHOKIDAR_CMD=\"$chokidar_full_cmd\"" >> "$ENV_FILE"
        log_info "Created $ENV_FILE with PM and CHOKIDAR_CMD."
        
        # Source the newly created .env file for the current session
        source_env_if_exists
        return 0
    else
        log_error "Failed to install chokidar-cli using $pm_choice."
        return 1
    fi
}

# --- Native Polling Watcher (Fallback) ---
run_polling_watcher() {
    log_info "Starting native polling watcher (fallback)."
    log_info "Watching for changes in .sh files. Polling every ${POLL_INTERVAL} seconds."
    log_info "(Press Ctrl+C in the terminal to stop this watcher)"

    _process_sh_files_poll() {
        log_info "POLL_WATCH: Processing .sh files..."
        find "${WORKSPACE_ROOT}" -type f -name "*.sh" -exec ls -l {} +
        find "${WORKSPACE_ROOT}" -type f -name "*.sh" -exec chmod +x {} +
        log_info "POLL_WATCH: Done processing."
    }

    _get_current_state_checksum_poll() {
        (find "${WORKSPACE_ROOT}" -type f -name "*.sh" -exec ls -l {} + 2>/dev/null | sort || true) | md5sum
    }

    _process_sh_files_poll # Initial run
    previous_state_checksum=$(_get_current_state_checksum_poll)

    while true; do
      sleep "${POLL_INTERVAL}"
      current_state_checksum=$(_get_current_state_checksum_poll)
      if [ "$current_state_checksum" != "$previous_state_checksum" ]; then
        log_info "POLL_WATCH: Changes detected at $(date +"%Y-%m-%d %H:%M:%S")"
        _process_sh_files_poll
        previous_state_checksum="$current_state_checksum"
      fi
    done
}

# --- Main Script Logic ---
main() {
    source_env_if_exists # Load CHOKIDAR_CMD if .env exists

    # Condition: .nvmrc is available and contains a valid node version
    if [ -f "$NVMRC_FILE" ]; then
        local nvmrc_node_version
        nvmrc_node_version=$(tr -d '[:space:]' < "$NVMRC_FILE") # Read and trim whitespace

        # Regex to check for version strings like "v18.0.0" or "18.0.0"
        if [[ "$nvmrc_node_version" =~ ^v?[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
            log_info ".nvmrc found with a valid-looking Node version: $nvmrc_node_version."

            # "the script immediately checks if CHOKIDAR_CMD is set"
            if [ -n "$CHOKIDAR_CMD" ]; then
                log_info "CHOKIDAR_CMD is set. As .nvmrc is valid, attempting to use chokidar-cli."
                # Optional: Add a check here if the active node version matches .nvmrc for extra safety/logging
                if check_command node; then
                    local current_node_version
                    current_node_version=$(node -v)
                    local norm_nvmrc_ver="${nvmrc_node_version#v}" # remove leading 'v' if present
                    local norm_curr_ver="${current_node_version#v}" # remove leading 'v' if present
                    if [ "$norm_curr_ver" != "$norm_nvmrc_ver" ]; then
                        log_warn "Active Node version ($current_node_version) does NOT match .nvmrc ($nvmrc_node_version). Using CHOKIDAR_CMD anyway as it is set."
                    else
                        log_info "Active Node version ($current_node_version) matches .nvmrc. Good."
                    fi
                else
                    log_warn "Node.js command not found. Using CHOKIDAR_CMD as it is set, but Node environment cannot be verified against .nvmrc."
                fi
                bash -c "$CHOKIDAR_CMD"
                return $? # Exit script after using chokidar
            else
                log_info ".nvmrc is valid, but CHOKIDAR_CMD is NOT set. Will proceed to standard flow (setup or polling)."
                # No return here, let the script continue to the next checks/setup
            fi
        else
            log_warn ".nvmrc found, but does not contain a valid-looking Node version string: '$nvmrc_node_version'. Proceeding with standard flow."
        fi
    # else: .nvmrc file not found, proceed with standard flow
    fi

    # Standard flow (if .nvmrc path didn't lead to an immediate chokidar execution with return)
    # Check if CHOKIDAR_CMD is set (could have been from .env, or .nvmrc path decided not to use it and fell through)
    if [ -n "$CHOKIDAR_CMD" ]; then
        log_info "CHOKIDAR_CMD is set (evaluated after .nvmrc specific check, or .nvmrc not applicable). Using chokidar-cli."
        bash -c "$CHOKIDAR_CMD"
        return $?
    fi

    # If CHOKIDAR_CMD is still not set/used, attempt setup
    log_info "CHOKIDAR_CMD not used or not set. Attempting chokidar setup..."
    if setup_chokidar_environment; then
        # setup_chokidar_environment sources .env, so CHOKIDAR_CMD should be available now
        if [ -n "$CHOKIDAR_CMD" ]; then # Check again after setup
            log_info "Chokidar setup successful. Using chokidar-cli."
            bash -c "$CHOKIDAR_CMD"
            return $?
        else
            log_error "Chokidar setup seemed to succeed, but CHOKIDAR_CMD is still not set. Critical error."
            # Fall through to polling
        fi
    else
        log_warn "Chokidar setup failed or was skipped."
        # Fall through to polling
    fi

    # Fallback to polling if all else fails
    log_warn "Falling back to native polling watcher."
    run_polling_watcher
    return $? # run_polling_watcher is an infinite loop, this return is for script completeness
}

# Trap SIGINT (Ctrl+C) and SIGTERM to allow for graceful exit if possible
trap 'log_info "Watcher script terminated."; exit 0' SIGINT SIGTERM

# Run the main logic
main

exit 0
