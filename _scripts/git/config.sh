#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$REPO_ROOT/scripts/core/_checks.sh"
source "$REPO_ROOT/scripts/core/_logging.sh"

# Load help function from config.help.sh
source "$REPO_ROOT/scripts/git/config.help.sh"

# Show help if requested
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  print_usage
  exit 0
fi

# Check if Git is installed, exit if not.
ensure_git() {
  log_info "Checking for Git..."
  check_install "git" "git"
}

# Recommend default branch name setting
recommend_default_branch() {
  log_info "💡 Recommendation:"
  log_info "  Use 'main' as the default branch name to follow modern Git conventions."
  log_info "  This aligns with most public repositories and new GitHub defaults."
}

# Setup default branch name in git config
setup_default_branch() {
  recommend_default_branch
  log_info "👉 Default branch name [main]: "
  read -r BRANCH_DEFAULT
  BRANCH_DEFAULT="${BRANCH_DEFAULT:-main}"
  git config --global init.defaultBranch "$BRANCH_DEFAULT"
  log_success "Set init.defaultBranch = '$BRANCH_DEFAULT'"
}

# Recommend Git editor setting
recommend_editor() {
  log_info "💡 Recommendation:"
  log_info "  Use 'code --wait' if you use VSCode, so Git waits for you to close the editor."
  log_info "  Nano is simple for beginners; Vim is powerful if you know it."
}

# Setup Git core editor
setup_editor() {
  recommend_editor
  log_info "👉 Preferred Git editor (nano, vim, code --wait) [skip]: "
  read -r GIT_EDITOR
  if [[ -n "${GIT_EDITOR}" ]]; then
    case "$GIT_EDITOR" in
      nano|vim|"code --wait")
        git config --global core.editor "$GIT_EDITOR"
        log_success "Set core.editor = '$GIT_EDITOR'"
        ;;
      *)
        log_warn "Unsupported editor. Skipping core.editor. Set manually if needed."
        ;;
    esac
  else
    log_info "Skipped core.editor setup."
  fi
}

# Recommend line endings config
recommend_line_endings() {
  log_info "💡 Recommendation:"
  log_info "  Setting core.autocrlf=false to avoid automatic line-ending conversion."
  log_info "  Adjust only if you work across Windows and Linux and experience issues."
}

# Setup line endings config
setup_line_endings() {
  recommend_line_endings
  git config --global core.autocrlf false
  log_success "Set core.autocrlf = false"
}

# Recommend pull behavior config
recommend_pull_behavior() {
  log_info "💡 Recommendation:"
  log_info "  Setting pull.rebase=true keeps a linear history by rebasing on pull."
  log_info "  This is preferred for cleaner project history."
}

# Setup pull behavior config
setup_pull_behavior() {
  recommend_pull_behavior
  log_info "🔧 Git pull behavior options:"
  log_info "  1) true (recommended)"
  log_info "  2) false"
  log_info "  3) preserve"
  log_info "👉 Choose pull behavior [1]: "
  read -r CHOICE
  case "${CHOICE:-1}" in
    2|f|false) VALUE=false ;;
    3|p|preserve) VALUE=preserve ;;
    *) VALUE=true ;;
  esac
  git config --global pull.rebase "$VALUE"
  log_success "Set pull.rebase = $VALUE"
}

# Recommend push behavior config
recommend_push_behavior() {
  log_info "💡 Recommendation:"
  log_info "  push.default=current is convenient when pushing current branch to its upstream."
  log_info "  Simple is safe and commonly used for simpler workflows."
}

# Setup push behavior config
setup_push_behavior() {
  recommend_push_behavior
  log_info "🔧 Git push.default options:"
  log_info "  1) current (recommended)"
  log_info "  2) simple"
  log_info "  3) upstream"
  log_info "  4) matching"
  log_info "  5) nothing"
  log_info "👉 Choose push.default behavior [1]: "
  read -r CHOICE
  case "${CHOICE:-1}" in
    2|s|simple) VALUE=simple ;;
    3|u|upstream) VALUE=upstream ;;
    4|m|matching) VALUE=matching ;;
    5|n|nothing) VALUE=nothing ;;
    *) VALUE=current ;;
  esac
  git config --global push.default "$VALUE"
  log_success "Set push.default = $VALUE"
}

# Recommend diff tool config
recommend_diff_tool() {
  log_info "💡 Recommendation:"
  log_info "  Use meld or kdiff3 for graphical diff tools."
  log_info "  vimdiff or code integrate well with terminal workflows."
}

# Setup diff tool config
setup_diff_tool() {
  recommend_diff_tool
  log_info "👉 Preferred diff tool (meld, kdiff3, vimdiff, code) [skip]: "
  read -r TOOL
  if [[ "$TOOL" =~ ^(meld|kdiff3|vimdiff|code)$ ]]; then
    git config --global diff.tool "$TOOL"
    log_success "Set diff.tool = $TOOL"

    log_info "👉 Prompt before launching diff tool? (1=false, 2=true) [1]: "
    read -r PROMPT
    case "${PROMPT:-1}" in
      2|t|true) PROMPT=true ;;
      *) PROMPT=false ;;
    esac
    git config --global difftool.prompt "$PROMPT"
    log_success "Set difftool.prompt = $PROMPT"
  elif [[ -n "$TOOL" ]]; then
    log_warn "'$TOOL' is not supported. Skipping diff.tool config."
  else
    log_info "Skipped diff.tool setup."
  fi
}

# Recommend user info (name/email)
recommend_user_info() {
  log_info "💡 Recommendation:"
  log_info "  Set your Git username and email to correctly attribute commits."
  log_info "  Use the email associated with your Git hosting account (GitHub, GitLab, etc.)."
}

# Setup user info config
setup_user_info() {
  recommend_user_info
  log_info "👉 Git username: "
  read -r NAME
  log_info "👉 Git email: "
  read -r EMAIL

  if [[ -n "$NAME" ]]; then
    git config --global user.name "$NAME"
    log_success "Set user.name = $NAME"
  fi
  if [[ -n "$EMAIL" ]]; then
    git config --global user.email "$EMAIL"
    log_success "Set user.email = $EMAIL"
  fi
}

# Print summary of configured Git settings
print_summary() {
  log_info "📊 Git Config Summary:"
  log_info "   user.name:  $(git config --global user.name || echo 'Not set')"
  log_info "   user.email: $(git config --global user.email || echo 'Not set')"
  log_info "   init.defaultBranch: $(git config --global init.defaultBranch || echo 'Not set')"
  log_info "   core.editor: $(git config --global core.editor || echo 'Not set')"
  log_info "   core.autocrlf: $(git config --global core.autocrlf || echo 'Not set')"
  log_info "   pull.rebase: $(git config --global pull.rebase || echo 'Not set')"
  log_info "   push.default: $(git config --global push.default || echo 'Not set')"
  log_info "   diff.tool: $(git config --global diff.tool || echo 'Not set')"
  log_info "Tip: For GitHub, consider setting up SSH keys or personal access tokens."
}

# Main entry point of the script
main() {
  log_info "🚀 Starting Git Configuration Wizard"

  ensure_git

  setup_default_branch
  setup_editor
  setup_line_endings
  setup_pull_behavior
  setup_push_behavior
  setup_diff_tool
  setup_user_info
  print_summary

  log_success "Git setup complete!"
}

main "$@"
