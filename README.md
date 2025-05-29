# 🛠️ devtoolkit

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=flat-square)](https://github.com/ctrlmaniac/devtoolkit/actions) <!-- Replace with your actual CI badge -->
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT) <!-- Assuming MIT, update if different -->
[![GitHub stars](https://img.shields.io/github/stars/ctrlmaniac/devtoolkit.svg?style=social&label=Star&maxAge=2592000)](https://github.com/ctrlmaniac/devtoolkit/stargazers/)

**`devtoolkit` is a comprehensive CLI toolkit designed to streamline developer workflows, from initial environment setup to ongoing project management within an Nx-friendly monorepo.**

It starts with a robust set of Bash scripts and is planned to evolve into an advanced Node.js-based CLI, offering a seamless and opinionated developer experience.

---

## ✨ Core Philosophy

The `devtoolkit` aims to:

*   **Automate Repetitive Tasks:** Reduce manual effort in setting up environments and managing projects.
*   **Enforce Best Practices:** Provide an opinionated setup for consistency and quality.
*   **Be Extensible:** Start with Bash for universal reach, evolve with Node.js for advanced features, and leverage Nx for monorepo power.
*   **Improve Developer Experience (DX):** Make development smoother, faster, and more enjoyable.

---

## 🚀 Key Features (Planned & In Progress)

As outlined in our [Roadmap](docs/roadmap.md):

-   **💻 System Setup:** Automate the installation and configuration of essential development tools and packages.
-   **🌿 Git & GitHub Integration:** Streamline Git configuration, SSH key management, and common repository operations.
-   **🟩 Node.js Environment:** Manage Node.js versions (via NVM) and package managers (npm, yarn, pnpm) effortlessly.
-   **🧱 Nx Workspace Ready:** Transform and manage your projects within an Nx-friendly monorepo structure.
-   **🧩 Repo-Centric Tooling:** Bootstrap new repositories with conventional commits, linters, formatters, and Git hooks.
-   **🔌 Custom Nx Plugins:** Extend Nx with tailored generators and executors for your specific stack and conventions.

---

## 🗺️ Roadmap

Our ambitious journey is detailed in the **`docs/roadmap.md`**. We are building this toolkit phase by phase, ensuring a solid foundation and incremental feature delivery.

---

## ⚙️ System Dependencies

Detailed information on system prerequisites, how `devtoolkit` manages dependencies via the
`.config/dependencies.txt` file, and manual installation steps can be found in:

➡️ **System Dependencies Setup**

**Project Installation (Conceptual):**

```bash
# Clone the repository (example)
git clone https://github.com/ctrlmaniac/devtoolkit.git
cd devtoolkit

# (Future) Installation script
# ./install.sh
```

---

## 🧑‍💻 Usage

*(This section will provide detailed usage instructions for each command as they are developed.)*

Currently, you can explore and run scripts from the `_scripts` directory. For example:

```bash
# Example: Navigate to a script directory
# cd _scripts/git

# Example: Run a script (ensure it's executable)
# ./config.sh
```

Refer to the Roadmap and individual script comments for current functionalities.

---

## 🤝 Contributing

Contributions are welcome! We're excited to build a vibrant community around `devtoolkit`. Please read our `CONTRIBUTING.md` (to be created) for guidelines on how to contribute.

Key areas for contribution:

*   Developing new scripts and commands.
*   Refactoring existing scripts for better performance and readability.
*   Improving documentation.
*   Testing and bug reporting.
*   Developing Node.js CLI features and Nx plugins.

---

## 🤖 AI-Assisted Development

This project leverages the power of AI to assist in code generation, brainstorming, and documentation. We believe in transparently acknowledging the tools that help us build better software, faster.

Built with the help of:

[!ChatGPT](https://openai.com/chatgpt)
[!Gemini](https://gemini.google.com/)

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE.md file for details (assuming MIT, please create this file and update if different).

---

✨ Let's build the ultimate CLI toolkit! ✨
