# Contributing to devtoolkit 🛠️

First off, thank you for considering contributing to `devtoolkit`! We aim to build a comprehensive and easy-to-use CLI toolkit, and your help is invaluable.

This document provides guidelines for contributing to the project. Please read it carefully to ensure a smooth and effective collaboration.

## 💬 How Can I Contribute?

There are many ways to contribute, including:

*   **🐛 Reporting Bugs:** If you find a bug, please open an issue on GitHub. Include as much detail as possible: steps to reproduce, expected behavior, actual behavior, and your environment (OS, shell, tool versions).
*   **✨ Suggesting Enhancements:** Have an idea for a new feature or an improvement to an existing one? Open an issue to discuss it.
*   **📝 Improving Documentation:** Good documentation is key. If you find areas that are unclear, incorrect, or could be improved, please let us know or submit a pull request. This includes the `README.md`, `roadmap.md`, help texts within scripts, and comments in the code.
*   **🧑‍💻 Writing Code:**
    *   Implementing new features as outlined in the Roadmap.
    *   Refactoring existing scripts for better readability, performance, or adherence to conventions.
    *   Adding tests for new or existing functionality.
*   **🧪 Testing:** Help us test new features and ensure existing ones work correctly across different environments.

## ⚙️ Development Setup

1.  **Fork the Repository:** Click the "Fork" button at the top right of the devtoolkit GitHub page.
2.  **Clone Your Fork:**
    ```bash
    git clone https://github.com/ctrlmaniac/devtoolkit.git
    cd devtoolkit
    ```
3.  **Prerequisites:** Ensure you have the necessary tools installed, as mentioned in the main `README.md` (Bash, common Unix utilities, and eventually Node.js/NVM).
4.  **Explore Existing Scripts:** Familiarize yourself with the scripts in the `_scripts` directory and the core helper functions in `_scripts/core/`.

## 📜 Coding Conventions

Please adhere to the following conventions:

*   **Shell Scripts (Bash/Zsh):**
    *   Follow the style and structure of existing scripts.
    *   Use `set -euo pipefail` at the beginning of Bash scripts.
    *   Utilize the logging functions from `_scripts/core/_logging.sh` (or `.zsh`).
    *   Utilize the check functions from `_scripts/core/_checks.sh` (or `.zsh`).
    *   Write clear and concise comments.
    *   Ensure scripts are executable (`chmod +x <script_name>`).
    *   Refer to our Coding Conventions for detailed guidelines.
*   **Node.js (Future):**
    *   We will establish conventions for Node.js development as we progress to Phase 5 of the roadmap. This will likely include Prettier for formatting and ESLint for linting.

##  COMMIT_MESSAGE_GUIDELINES ##

We aim to use **Conventional Commits**. This makes the commit history more readable and allows for automated changelog generation.

A commit message should be structured as follows:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Common types:**

*   `feat`: A new feature
*   `fix`: A bug fix
*   `docs`: Documentation only changes
*   `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
*   `refactor`: A code change that neither fixes a bug nor adds a feature
*   `perf`: A code change that improves performance
*   `test`: Adding missing tests or correcting existing tests
*   `chore`: Changes to the build process or auxiliary tools and libraries such as documentation generation

We plan to integrate `git-cz` (Commitizen) to help with formatting commit messages (see Roadmap Phase 6).

## 🚀 Submitting Changes

1.  **Create a Branch:** Create a new branch for your changes from the `main` branch (or `develop` if we establish one later).
    ```bash
    git checkout -b feat/your-awesome-feature
    ```
2.  **Make Your Changes:** Implement your feature or fix the bug.
3.  **Test Your Changes:** Ensure your changes work as expected and don't break existing functionality.
4.  **Commit Your Changes:** Follow the Commit Message Guidelines.
5.  **Push to Your Fork:**
    ```bash
    git push origin feat/your-awesome-feature
    ```
6.  **Open a Pull Request (PR):** Go to the original `devtoolkit` repository on GitHub and open a pull request from your forked branch to the `main` branch of `ctrlmaniac/devtoolkit`.
    *   Provide a clear title and description for your PR.
    *   Reference any related issues (e.g., "Closes #123").

## 🙏 Thank You!

Your contributions will help make `devtoolkit` a valuable tool for developers. We appreciate your time and effort!
