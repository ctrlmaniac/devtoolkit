#!/usr/bin/env bash
# shellcheck source=../utils/check-install.sh

echo -e "\n🚀 Welcome to your WSL Git Setup Wizard!\n"

# Assuming this script (login.sh) is in sh/git/
# and check-install.sh is in sh/utils/
CURRENT_SCRIPT_DIR_LOGIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CHECK_INSTALL_SCRIPT_PATH_LOGIN="${CURRENT_SCRIPT_DIR_LOGIN}/../utils/check-install.sh"

# Function to manually check for a command if check-install.sh is not available
_manual_check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: Command '$1' not found. Please install '$2' (or the package providing it) and try again."
        exit 1
    fi
    echo "Info: Command '$1' found."
}

if [ -f "${CHECK_INSTALL_SCRIPT_PATH_LOGIN}" ]; then
    source "${CHECK_INSTALL_SCRIPT_PATH_LOGIN}"
    # Check/install git (assuming check_install "command" "package_name_suggestion")
    check_install "git" "git"
else
    echo "Warning: Utility script ${CHECK_INSTALL_SCRIPT_PATH_LOGIN} not found."
    echo "Proceeding with manual check for git."
    _manual_check_command "git" "git"
fi

# Configure Git
echo -e "\n⚙️ Let's configure your Git."

# Default branch name
echo -e "\n🔧 Set the default branch name for new repositories (e.g., main, master, development)."
read -r -p "👉 Default branch name [main]: " BRANCH_DEFAULT
BRANCH_DEFAULT="${BRANCH_DEFAULT:-main}"
if [ -n "$BRANCH_DEFAULT" ]; then
    git config --global init.defaultBranch "$BRANCH_DEFAULT"
    echo "   Set init.defaultBranch to '$BRANCH_DEFAULT'."
else
    echo "   No default branch name specified. Skipping init.defaultBranch configuration."
fi

# Configure core editor
echo -e "\n🔧 Set your preferred Git editor (e.g., nano, vim, 'code --wait'). Leave blank to skip."
read -r -p "👉 Git editor: " GIT_EDITOR

if [ -z "$GIT_EDITOR" ]; then
    echo "   No editor specified. Skipping core.editor configuration."
elif [[ "$GIT_EDITOR" == "nano" || "$GIT_EDITOR" == "vim" || "$GIT_EDITOR" == "code --wait" ]]; then
    git config --global core.editor "$GIT_EDITOR"
    echo "   Set core.editor to '$GIT_EDITOR'."
else
    echo "   '$GIT_EDITOR' is not one of the explicitly validated options (nano, vim, 'code --wait')."
    echo "   Skipping core.editor configuration. If you are sure and wish to use '$GIT_EDITOR',"
    echo "   you can set it manually: git config --global core.editor \"$GIT_EDITOR\""
fi


# Configure line endings for WSL
echo -e "\n🔧 Configuring line endings for WSL (core.autocrlf=false)."
echo "   This helps prevent issues when working with files from different operating systems."
git config --global core.autocrlf false
echo "   Set core.autocrlf to false."

# Configure pull rebase
echo -e "\n🔧 Configure default behavior for 'git pull' (pull.rebase)."
echo "   Using 'rebase' (true) can lead to a cleaner, more linear project history."
echo "   Options:"
echo "     1) true (recommended: rebase local commits on top of fetched changes)"
echo "     2) false (create a merge commit when pulling)"
echo "     3) preserve (deprecated: rebase but preserve merge commits)"
read -r -p "👉 Choose pull behavior [1]: " PULL_REBASE_CHOICE
PULL_REBASE_CHOICE="${PULL_REBASE_CHOICE:-1}"

case "$PULL_REBASE_CHOICE" in
    1|t|true)
        git config --global pull.rebase true
        echo "   Set pull.rebase to true."
        ;;
    2|f|false)
        git config --global pull.rebase false
        echo "   Set pull.rebase to false."
        ;;
    3|p|preserve)
        git config --global pull.rebase preserve
        echo "   Set pull.rebase to preserve."
        ;;
    *)
        echo "   Invalid choice. Setting pull.rebase to true (recommended)."
        git config --global pull.rebase true
        ;;
esac

# Configure push default
echo -e "\n🔧 Configure default behavior for 'git push' (push.default)."
echo "   'current' or 'simple' are common recommendations."
echo "   Options:"
echo "     1) current (recommended: push the current branch to a remote branch of the same name)"
echo "     2) simple (default in newer Git: like 'current' but with more safety checks)"
echo "     3) upstream (push the current branch to its configured upstream branch)"
echo "     4) matching (push all local branches that exist on the remote; can be risky)"
echo "     5) nothing (do not push anything by default; requires explicit refspec)"
read -r -p "👉 Choose push default behavior [1]: " PUSH_DEFAULT_CHOICE
PUSH_DEFAULT_CHOICE="${PUSH_DEFAULT_CHOICE:-1}"

case "$PUSH_DEFAULT_CHOICE" in
    1|c|current)
        git config --global push.default current
        echo "   Set push.default to current."
        ;;
    2|s|simple)
        git config --global push.default simple
        echo "   Set push.default to simple."
        ;;
    3|u|upstream)
        git config --global push.default upstream
        echo "   Set push.default to upstream."
        ;;
    4|m|matching)
        git config --global push.default matching
        echo "   Set push.default to matching."
        ;;
    5|n|nothing)
        git config --global push.default nothing
        echo "   Set push.default to nothing."
        ;;
    *)
        echo "   Invalid choice. Setting push.default to current (recommended)."
        git config --global push.default current
        ;;
esac

# Configure diff tool (optional)
echo -e "\n🔧 Configure an external diff tool (optional)."
echo "   If you have a preferred visual diff tool (e.g., meld, kdiff3, vimdiff), enter its name."
echo "   'meld' is a good choice if available. Leave blank to skip."
echo "   Validated options: meld, kdiff3, vimdiff, code"
read -r -p "👉 Enter preferred diff tool: " GIT_DIFF_TOOL

if [ -z "$GIT_DIFF_TOOL" ]; then
    echo "   No external diff tool specified. Git will use its default diff mechanism."
elif [[ "$GIT_DIFF_TOOL" == "meld" || "$GIT_DIFF_TOOL" == "kdiff3" || "$GIT_DIFF_TOOL" == "vimdiff" || "$GIT_DIFF_TOOL" == "code" ]]; then
    git config --global diff.tool "$GIT_DIFF_TOOL"
    echo "   Set diff.tool to '$GIT_DIFF_TOOL'."

    # Configure difftool.prompt (only if a diff tool is set)
    echo -e "\n   Configure if Git should prompt before launching '$GIT_DIFF_TOOL' for each file (difftool.prompt)."
    echo "   'false' (no prompt) is often more convenient."
    echo "   Note: For 'code' (VS Code), you might need to configure 'difftool.vscode.cmd' separately if not already set up."
    echo "   Options:"
    echo "     1) false (recommended: do not prompt, launch '$GIT_DIFF_TOOL' directly)"
    echo "     2) true (prompt before launching '$GIT_DIFF_TOOL' for each file)"
    read -r -p "👉 Prompt before each diff tool launch? [1]: " DIFFTOOL_PROMPT_CHOICE
    DIFFTOOL_PROMPT_CHOICE="${DIFFTOOL_PROMPT_CHOICE:-1}"

    if [[ "$DIFFTOOL_PROMPT_CHOICE" == "1" || "$DIFFTOOL_PROMPT_CHOICE" == "f" || "$DIFFTOOL_PROMPT_CHOICE" == "false" ]]; then
        git config --global difftool.prompt false
        echo "   Set difftool.prompt to false."
    elif [[ "$DIFFTOOL_PROMPT_CHOICE" == "2" || "$DIFFTOOL_PROMPT_CHOICE" == "t" || "$DIFFTOOL_PROMPT_CHOICE" == "true" ]]; then
        git config --global difftool.prompt true
        echo "   Set difftool.prompt to true."
    else
        echo "   Invalid choice for difftool.prompt. Setting to false (recommended)."
        git config --global difftool.prompt false
    fi
else
    echo "   '$GIT_DIFF_TOOL' is not one of the explicitly validated options (meld, kdiff3, vimdiff, code)."
    echo "   Skipping diff.tool configuration. If you are sure and wish to use '$GIT_DIFF_TOOL',"
    echo "   you can set it manually: git config --global diff.tool \"$GIT_DIFF_TOOL\""
    echo "   You may also need to configure 'difftool.$GIT_DIFF_TOOL.cmd' if it's a custom tool."
fi

# Get GitHub credentials
echo -e "\n⚙️ Let's configure your Git user details for commit authorship."

echo -e "\nPlease enter your Git username:"
echo "ℹ️ This name will appear in your commits. It can be your GitHub username or your real name."
read -r -p "👉 Your Git username: " GIT_USER

echo -e "\nPlease enter your Git email address:"
echo "ℹ️ This email will appear in your commits. Use an email associated with your GitHub account for proper commit attribution on GitHub."
read -r -p "👉 Your Git email: " GIT_EMAIL

# Configure Git user details
if [ -n "$GIT_USER" ]; then
    git config --global user.name "$GIT_USER"
    echo "   Git global user.name set to: $GIT_USER"
else
    echo "   Username not provided. Skipping global user.name configuration."
    echo "   You can set it later with: git config --global user.name \"Your Name\""
fi

if [ -n "$GIT_EMAIL" ]; then
    git config --global user.email "$GIT_EMAIL"
    echo "   Git global user.email set to: $GIT_EMAIL"
else
    echo "   Email not provided. Skipping global user.email configuration."
    echo "   You can set it later with: git config --global user.email \"your.email@example.com\""
fi
echo

# Configure credential helper for caching (optional, but recommended for HTTPS)
# This is typically handled by Git for Windows or specific Linux setups.
# For WSL, you might need the 'wsl-credential-helper' or similar.
# We'll skip automatic setup here as it's environment-dependent.
# echo "Consider setting up a credential helper for convenience (e.g., git config --global credential.helper store)"

# Final Git Configuration Summary
echo -e "\n📊 Current Git User Configuration (from 'git config --global'):"
current_git_user=$(git config --global user.name)
current_git_email=$(git config --global user.email)
echo "   Global user.name: ${current_git_user:-Not set}"
echo "   Global user.email: ${current_git_email:-Not set}"

echo -e "\n💡 Tip: For pushing to GitHub, ensure you have SSH keys (recommended) or a Personal Access Token configured."

echo "✨ All done! Ready to rock your code in WSL! 🚀"
