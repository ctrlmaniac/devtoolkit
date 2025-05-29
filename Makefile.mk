# Makefile for devtoolkit

# Determine the project root directory (where this Makefile is located)
PROJECT_ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Define DEVTOOLKIT path based on the project root and export it
# This ensures it's correct regardless of where 'make' is called from,
# as long as it's called on this Makefile.
export DEVTOOLKIT := $(PROJECT_ROOT)/devtoolkit

# Find all shell scripts to lint.
# Adjust exclusions as necessary (e.g., -not -path "$(PROJECT_ROOT)/vendor/*").
SHELL_SCRIPTS_TO_LINT := $(shell find $(PROJECT_ROOT) -name '*.sh' -not -path "$(PROJECT_ROOT)/.git/*")

.PHONY: lint
lint:
	@echo "Linting shell scripts..."
	@echo "PROJECT_ROOT is set to: $(PROJECT_ROOT)"
	@echo "DEVTOOLKIT is set to: $(DEVTOOLKIT)"
	@if [ -z "$(SHELL_SCRIPTS_TO_LINT)" ]; then \
		echo "No shell scripts found to lint."; \
	else \
		shellcheck $(SHELL_SCRIPTS_TO_LINT); \
	fi
	@echo "Linting complete."

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  lint    - Lint all shell scripts in the project using shellcheck."
