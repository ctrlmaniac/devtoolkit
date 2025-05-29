# ✨ Devtoolkit CLI Manifesto - Conventions & Structure ✨

Welcome to the official **Devtoolkit CLI** architecture manifesto!
This document defines the conventions, structure, and design principles that guide our CLI development. Reference this file in `CONTRIBUTING.md` to maintain consistency across contributors.

---

## 🗂 Project Layout

```bash
$ROOT/
├── bin/
│   └── devtoolkit                    # 🎯 Entry point CLI dispatcher (Bash or Snap-compatible)
│
└── devtoolkit/                       # 📦 $DEVTOOLKIT root
    ├── utils/                        # 🔁 Shared utility functions
    │   ├── welcome.sh               # 💬 Styled headers
    │   ├── goodbye.sh               # 👋 Exit banners
    │   ├── confirm.sh               # ✅ Prompt Y/N confirmation
    │   ├── log.sh                  # 📜 Logging helpers
    │   ├── check-command.sh         # 🔍 Check for command
    │   ├── check-command-install.sh # 📦 Check & install missing command
    │   └── check-command-abort.sh   # 🛑 Abort if command missing
    │
    ├── commands/                    # 🧠 Executable commands (dispatched)
    │   ├── command.sh               # e.g. "git.sh"
    │   └── command/
    │       └── subcommand.sh        # e.g. "config.sh"
    │
    └── libs/                        # 🧩 Logic partials (modular helpers per command)
        ├── sys/
        ├── sys-install/
        ├── git/
        ├── git-config/
        ├── github/
        ├── github-ssh-key/
        ├── github-ssh-key-gen/
        └── github-ssh-key-check/
```

---

## 📜 Naming & File Conventions

### ✅ `bin/devtoolkit`

* Main entry point for the CLI
* Pure dispatcher: parses commands and routes to `commands/`
* No core logic inside this file

### 🛠 `utils/` - Shared Helpers

* Files use **kebab-case**
* All functions in these files are **globally reusable**
* Examples:

  * `welcome.sh` → `print_header "..."`
  * `goodbye.sh` → `print_goodbye "..."`
  * `confirm.sh` → `confirm "Continue?"`

### 🧱 `libs/` - Partial Logic Per Command

* Contain command-specific internal functions
* Organized by namespace (e.g., `github/`, `git/`, `sys/`)
* Filenames start with `_` if the logic is internal only
* Example: `_check-installed.sh`, `_gen-key.sh`

### ⚙️ `commands/` - Entry Executables

* Represent actual CLI-exposed commands
* Structure:

  * `commands/<command>.sh`
  * `commands/<command>/<subcommand>.sh`
* These files call reusable utils and `libs/` partials

---

## 🎨 UX & Output Rules

### 🪄 Command Start

All commands must begin with a styled header:

```bash
print_header "🔧 Installing Node.js..."
```

### 👋 Command End

All commands must end with a goodbye message:

```bash
print_goodbye "✅ Node.js installed successfully!"
```

### ❓ Confirmation Prompts

In orchestrated/interactive commands (e.g., bootstrap):

```bash
confirm "Do you want to continue to setup Git? (y/n)"
```

* Accepts `y`, `yes`, `n`, `no` (case-insensitive)
* `no` exits the workflow

### 📘 Help Flags

* Use only `--help` or `-h`
* Do **not** create a `help` subcommand

---

## 🔁 Example CLI Usages

```bash
$ devtoolkit --help
$ devtoolkit sys --help
$ devtoolkit github ssh-key-check
$ devtoolkit git config
```

---

## 📚 Summary

| Component | Purpose                           | File Location                    |
| --------- | --------------------------------- | -------------------------------- |
| Entry CLI | Dispatch input                    | `bin/devtoolkit`                 |
| Utils     | Shared tools (header, log, etc.)  | `devtoolkit/utils/*.sh`          |
| Commands  | Entry command scripts             | `devtoolkit/commands/**/*.sh`    |
| Libs      | Partial logic helpers per command | `devtoolkit/libs/{domain}/_*.sh` |

---

> 💡 This structure ensures modularity, reusability, and cross-shell compatibility. Stick to it and your CLI code will be clean, scalable, and fun to maintain! 🚀
