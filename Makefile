# delements-web-stack — Makefile
# Idempotent setup for Figma + Webflow + Shopify on OpenClaw

SHELL := /bin/bash
SCRIPTS_DIR := scripts
ENV_FILE := env/.env

.PHONY: all preflight openclaw figma webflow shopify agents local-programs auth plugins verify clean help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

all: preflight openclaw figma webflow shopify agents local-programs auth plugins verify ## Full setup (recommended)

preflight: ## Check system dependencies
	@bash $(SCRIPTS_DIR)/00-preflight.sh

openclaw: preflight ## Install OpenClaw
	@bash $(SCRIPTS_DIR)/01-install-openclaw.sh

figma: ## Setup Figma MCP server + plugin
	@bash $(SCRIPTS_DIR)/02-setup-figma.sh

webflow: ## Setup Webflow MCP
	@bash $(SCRIPTS_DIR)/03-setup-webflow.sh

shopify: ## Setup Shopify CLI + MCP
	@bash $(SCRIPTS_DIR)/04-setup-shopify.sh

agents: ## Configure BSI agents in OpenClaw
	@bash $(SCRIPTS_DIR)/05-configure-agents.sh

local-programs: ## Copy local programs to $BSI_ROOT
	@bash $(SCRIPTS_DIR)/09-copy-local-programs.sh

auth: ## Setup OpenClaw auth profiles
	@bash $(SCRIPTS_DIR)/07-setup-auth.sh

plugins: ## Setup OpenClaw plugins
	@bash $(SCRIPTS_DIR)/08-setup-plugins.sh

verify: ## Verify all integrations
	@bash $(SCRIPTS_DIR)/06-verify.sh

clean: ## Remove installed configs (does NOT delete repo)
	@echo "⚠️  This will remove BSI agent configs from ~/.openclaw"
	@echo "   It will NOT delete this repo or your .env file."
	@read -p "Continue? [y/N] " confirm && [ "$$confirm" = "y" ] || exit 1
	@echo "🗑️  Cleaning..."
	@# Agents are preserved — only MCP entries are removed from openclaw.json
	@echo "✅  Done. Re-run 'make all' to reinstall."
