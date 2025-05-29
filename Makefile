# Makefile for devtoolkit

# Define the shell to use
SHELL := /bin/bash

# Phony targets are not actual files
.PHONY: lint lint-shell help

# Default target when 'make' is run without arguments
all: help

# Linting targets
lint: lint-shell ## Run all linters

lint-shell: ## Run shellcheck on shell scripts
	@echo "⚙️ Ensuring shell scripts are executable..."
	@find ./bin ./scripts ./devtoolkit -type f -name '*.sh' -exec chmod +x {} +
	@echo "🔍 Running shellcheck on shell scripts..."
	@scripts/shellcheck.sh

# Help target to display available commands
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
