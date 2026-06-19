#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 01-install-openclaw.sh — Install OpenClaw if not present
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "  ${GREEN}ℹ️${NC}  $1" }
warn() { echo -e "  ${YELLOW}⚠️${NC}  $1" }

echo "📦 Installing OpenClaw..."
echo ""

if command -v openclaw &>/dev/null; then
  info "OpenClaw already installed: $(openclaw --version 2>/dev/null || echo 'unknown')"
  echo "  To update: npm update -g openclaw"
else
  info "Installing OpenClaw globally..."
  npm install -g openclaw
  info "OpenClaw installed: $(openclaw --version 2>/dev/null || echo 'done')"
fi

echo ""
echo -e "${GREEN}✅ OpenClaw ready.${NC}"
