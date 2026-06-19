#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 00-preflight.sh — Check system dependencies
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}[OK]${NC} $1"; }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; }

ERRORS=0

echo "Checking system dependencies..."
echo ""

# --- macOS ---
if [[ "$(uname)" == "Darwin" ]]; then
  pass "macOS $(sw_vers -productVersion 2>/dev/null || echo 'unknown')"
else
  fail "macOS required (current: $(uname))"
  ERRORS=$((ERRORS + 1))
fi

# --- Homebrew ---
if command -v brew &>/dev/null; then
  pass "Homebrew $(brew --version | head -1)"
else
  fail "Homebrew not found - install from https://brew.sh"
  ERRORS=$((ERRORS + 1))
fi

# --- Node.js ---
if command -v node &>/dev/null; then
  NODE_VER=$(node -v)
  NODE_MAJOR=$(echo "$NODE_VER" | sed 's/v//' | cut -d. -f1)
  if [[ "$NODE_MAJOR" -ge 20 ]]; then
    pass "Node.js $NODE_VER"
  else
    warn "Node.js $NODE_VER (recommend >= v20)"
  fi
else
  fail "Node.js not found - brew install node"
  ERRORS=$((ERRORS + 1))
fi

# --- npm ---
if command -v npm &>/dev/null; then
  pass "npm $(npm -v)"
else
  fail "npm not found"
  ERRORS=$((ERRORS + 1))
fi

# --- npx ---
if command -v npx &>/dev/null; then
  pass "npx available"
else
  fail "npx not found (comes with npm ≥ 5.2)"
  ERRORS=$((ERRORS + 1))
fi

# --- git ---
if command -v git &>/dev/null; then
  pass "git $(git --version | awk '{print $3}')"
else
  warn "git not found - needed for Figma MCP clone"
fi

# --- OpenClaw ---
if command -v openclaw &>/dev/null; then
  pass "OpenClaw $(openclaw --version 2>/dev/null || echo 'installed')"
else
  warn "OpenClaw not found - will be installed by 01-install-openclaw.sh"
fi

# --- .env file ---
ENV_FILE="env/.env"
if [[ -f "$ENV_FILE" ]]; then
  pass "env/.env exists"
  
  # Source and validate
  set -a
  source "$ENV_FILE"
  set +a
  
  if [[ -n "${SHOPIFY_ACCESS_TOKEN:-}" ]]; then
    pass "SHOPIFY_ACCESS_TOKEN is set"
  else
    warn "SHOPIFY_ACCESS_TOKEN not set in .env"
  fi
  
  if [[ -n "${SHOPIFY_DOMAIN:-}" ]]; then
    pass "SHOPIFY_DOMAIN = $SHOPIFY_DOMAIN"
  else
    warn "SHOPIFY_DOMAIN not set in .env"
  fi
  
  if [[ -n "${WEBFLOW_TOKEN:-}" ]]; then
    pass "WEBFLOW_TOKEN is set"
  else
    warn "WEBFLOW_TOKEN not set in .env"
  fi
else
  warn "env/.env not found - run: cp env/.env.example env/.env"
fi

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo -e "${RED}[FAIL] $ERRORS critical issue(s) found. Fix before continuing.${NC}"
  exit 1
else
  echo -e "${GREEN}[OK] Preflight check passed!${NC}"
fi
