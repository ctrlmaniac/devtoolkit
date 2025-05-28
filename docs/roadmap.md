# 🗺 Roadmap: devtoolkit CLI Evolution

This file outlines the step-by-step journey to build and evolve the `devtoolkit` CLI from a Bash-first monorepo bootstrapper to a powerful Node.js-based CLI. Each milestone below represents a well-defined and incremental stage in the development lifecycle.

---

## 📦 Phase 1: Define Command Structure

Establish a consistent and maintainable command structure for all scripts.

*   Define core script functions (e.g., header, main, help, goodbye functions).
*   Standardize argument parsing and validation mechanisms.
*   Implement robust error handling and logging, leveraging shared core scripts like `_logging.sh` and `_checks.sh`.
*   Ensure comprehensive and consistent help messages (`print_usage`) for all commands.

---

## 🔧 Phase 2: Build Command Workflows

Implement domain-specific commands, organized logically (e.g., under `$DEVTOOLKIT/scripts/<domain>`):

*   **System (`sys`) Commands:** Scripts for system setup, package management, and environment validation.
*   **Git (`git`) Commands:** Tools for Git configuration, common aliases, and repository operations.
*   **GitHub (`github`) Commands:** Utilities for SSH key management, API interactions, and repository setup.
*   **Node.js (`node`) Commands:** Scripts for NVM installation, Node.js version management, and package manager (npm, yarn, pnpm) setup.

---

## 🧱 Phase 3: Migrate to Nx Workspace

Transform the repository into an Nx-friendly monorepo for enhanced scalability, organization, and task management.

*   Restructure the repository to align with Nx workspace conventions.
*   Implement a well-defined monorepo structure using Nx.
*   Define initial Nx projects for existing script libraries and plan for future Node.js applications/libraries.
*   Configure core Nx settings (`nx.json`, `workspace.json` or `project.json` files).

---

## 🧰 Phase 4: Finalize Node Environment Setup

Solidify and provide comprehensive tooling for the Node.js development environment.

*   Finalize and ensure robustness of scripts for Node.js environment setup (NVM, specific Node versions, package managers).
*   Install and configure a set of recommended global Node.js CLI tools for enhanced development workflow.
*   Ensure seamless interoperability and integration points between Bash scripts and Node.js tools/scripts.

---

## 🚀 Phase 5: Advanced Node-based CLI

Develop a sophisticated Node.js-based CLI application that mirrors and extends the capabilities of the Bash scripts.

*   Create a primary Node.js CLI application using modern frameworks (e.g., `commander.js`, `yargs`, `oclif`).
*   Replicate and enhance the functionalities of the existing Bash scripts within the Node.js CLI.
*   Implement a mechanism for the Bash CLI to intelligently call the Node.js CLI if Node.js is installed, offering a unified user experience.
*   Plan the eventual transition where the Node.js CLI becomes the primary interface, potentially wrapping or replacing Bash components.

---

## 🧩 Phase 6: Repo-Centric Tooling

Implement a Node.js-based, repository-centric environment to bootstrap new projects with a complete and opinionated development setup.

*   Develop tools and scripts for initializing new projects with a standardized structure and tooling.
*   Bootstrap repositories by automatically installing and configuring recommended development tools:
    *   `git-cz` (Commitizen) for conventional commit messages.
    *   Prettier for consistent code formatting.
    *   ESLint for code linting and quality checks.
    *   Husky for managing Git hooks (e.g., pre-commit, pre-push).
*   Provide sensible default configurations for all bootstrapped tools.

---

## 🧪 Phase 7: Nx Plugins for Our Stack

Extend the Nx workspace capabilities by creating custom plugins, generators (schematics), and executors tailored to the project's specific needs and conventions.

*   Develop Nx plugins to integrate tools or automate setup for technologies not natively supported by Nx.
*   Create Nx generators for scaffolding new libraries, applications, or modules that adhere to the project's recommended features, structure, and boilerplate.
*   Implement Nx executors for automating common or custom workspace tasks, such as specialized build processes, deployment scripts, or code generation steps.

---

## 🏁 Final Goal

📦 A full-stack monorepo CLI toolkit written in Node.js and Bash, able to:

* Setup new developer environments
* Bootstrap repositories and toolchains
* Offer reusable Nx plugins and scripts
* Provide seamless, opinionated developer experience across environments

✨ Let's build the ultimate CLI toolkit! ✨
