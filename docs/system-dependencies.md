# ⚙️ System Dependencies Setup

To prepare your development environment, `devtoolkit` relies on several system-level packages installable via `apt` and `snap`.
These dependencies, including how they are installed (apt, snap, curl) and whether they are optional,
are defined in a unified file:

*   `.config/dependencies.txt`

## Prerequisites

Before using `devtoolkit` or attempting to install its managed dependencies, ensure your system has:

*   Bash (and/or Zsh for Zsh-specific scripts)
*   Common Unix utilities (curl, git, etc.)
*   For Debian/Ubuntu based systems:
    *   `apt` package manager
    *   `snapd` for snap packages (usually pre-installed on Ubuntu)
*   (Soon) Node.js and NVM for Node-based features

## Installing System Dependencies

`devtoolkit` aims to automate the installation of these dependencies (e.g., via a `devtoolkit setup-env` or `devtoolkit deps install` command).
This command will parse the `.config/dependencies.txt` file and handle the installation logic.

### Understanding the `.config/dependencies.txt` format

The detailed format, including how to parse it, is defined at the top of the `.config/dependencies.txt` file itself.
Here's a summary of the general structure:

` <[?]dependency[.exe]> [INSTALL_OPTIONS] [FOOTNOTE_REF]`

*   `PACKAGE_NAME`: The canonical name of the tool.
    *   Can be prefixed with `?` for optional dependencies (e.g., `?unzip`).
    *   Can be suffixed with `.exe` for Windows-specific programs.
*   `INSTALL_OPTIONS`: These are specific flags or directives to indicate the installation method and its parameters.
    *   **Snap:** Uses the `--snap` flag followed by any valid arguments for the `snap install` command (e.g., `--classic`, `--channel=beta`, `--edge`). For example: `code --snap --classic`.
    *   **Script (Curl/Wget):** Uses a special `@(URL_AND_COMMAND_STRING)` syntax. For example: `cargo @(https://sh.rustup.rs -sSf | sh)`.
    *   **Default (APT):** If no specific install options are provided, installation via `apt` is generally assumed for Debian/Ubuntu systems (e.g., `git`).
*   `FOOTNOTE_REF`: A Markdown-style footnote (e.g., `[^1]`) can be used to link to prerequisite dependencies defined elsewhere in the file.

Please refer to the header comments within `.config/dependencies.txt` for the precise `USAGE` definition and `HOW TO PARSE` guidelines.

### Manual Installation (Interim)

Until the automated installation command is fully implemented in `devtoolkit`, you can refer to the
`.config/dependencies.txt` file to understand what needs to be installed and use your system's
package managers (`apt`, `snap`), or `curl` as per the definitions in the file.

For example, based on the format in `.config/dependencies.txt`:
*   An entry like `git` implies `sudo apt install git`.
*   An entry like `code --snap --classic` would imply `sudo snap install code --classic`.
*   An entry `my-app --snap --channel=beta --edge` would imply `sudo snap install my-app --channel=beta --edge`.
*   An entry `cargo @(https://sh.rustup.rs -sSf | sh) [^1]` implies installing Rust by running `curl -sSf https://sh.rustup.rs | sh`, after ensuring its prerequisite `[^1]` (e.g., `build-essential`) is met.

### Example Snippets for Manual Installation

The following are conceptual examples of how you might manually process parts of the dependency list. **Note:** These snippets are illustrative and do not parse the full `.config/dependencies.txt` format. They assume you've manually extracted lists of apt or snap packages.

**1. APT Packages (Conceptual)**
```bash
# Assuming you have a list of apt packages in a temporary file 'apt_list.txt'
# sudo apt-get update && xargs -r -a apt_list.txt -- sudo apt-get install -y
```

**2. Snap Packages (Conceptual)**
```bash
# Assuming you have a list of snap packages (one per line, with flags) in 'snap_list.txt'
# while IFS= read -r pkg_line; do if [[ -n "$pkg_line" ]]; then sudo snap install $pkg_line; fi; done < snap_list.txt
```
