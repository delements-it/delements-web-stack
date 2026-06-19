#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 06-verify.sh — Verify all integrations
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}[OK]${NC} $1"; }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; }

OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"
ENV_FILE="env/.env"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

FIGMA_MCP_DIR="${FIGMA_MCP_DIR:-$HOME/Documents/WORKSPACES/AI Coding Tools/figma-mcp-server}"

echo "Verifying web stack integrations..."
echo ""

# --- Figma ---
echo "Figma:"
if [[ -d "$FIGMA_MCP_DIR/mcp" ]]; then
  pass "MCP server repo exists"
else
  fail "MCP server repo missing"
fi

if [[ -f "$FIGMA_MCP_DIR/plugin/manifest.json" ]]; then
  pass "Plugin manifest exists"
else
  fail "Plugin manifest missing"
fi

if python3 -c "import json; d=json.load(open('$OPENCLAW_JSON')); assert 'figma' in d.get('mcp',{}).get('servers',{})" 2>/dev/null; then
  pass "MCP config in openclaw.json"
else
  fail "MCP config missing from openclaw.json"
fi

echo ""

# --- Webflow ---
echo "Webflow:"
if python3 -c "import json; d=json.load(open('$OPENCLAW_JSON')); assert 'webflow' in d.get('mcp',{}).get('servers',{})" 2>/dev/null; then
  pass "MCP config in openclaw.json"
else
  fail "MCP config missing from openclaw.json"
fi

if [[ -f "$HOME/.openclaw/workspace/config/mcporter.json" ]]; then
  if python3 -c "import json; d=json.load(open('$HOME/.openclaw/workspace/config/mcporter.json')); assert 'webflow' in d.get('mcpServers',{})" 2>/dev/null; then
    pass "mcporter OAuth config"
  else
    warn "mcporter config exists but Webflow entry missing"
  fi
else
  warn "mcporter config not found (optional)"
fi

echo ""

# --- Shopify ---
echo "Shopify:"
if command -v shopify &>/dev/null; then
  pass "Shopify CLI: $(shopify version 2>/dev/null || echo 'installed')"
else
  fail "Shopify CLI not installed"
fi

if python3 -c "import json; d=json.load(open('$OPENCLAW_JSON')); assert 'shopify' in d.get('mcp',{}).get('servers',{})" 2>/dev/null; then
  pass "Shopify MCP config"
else
  fail "Shopify MCP config missing"
fi

if python3 -c "import json; d=json.load(open('$OPENCLAW_JSON')); assert 'shopify-dev-mcp' in d.get('mcp',{}).get('servers',{})" 2>/dev/null; then
  pass "Shopify Dev MCP config"
else
  fail "Shopify Dev MCP config missing"
fi

echo ""

# --- Agents ---
echo "BSI Agents:"
for agent in bsi-figma-mcp bsi-figma-executor bsi-webflow-mcp bsi-webflow-executor bsi-shopify-mcp bsi-shopify-executor; do
  if python3 -c "import json; d=json.load(open('$OPENCLAW_JSON')); assert '$agent' in [a['id'] for a in d.get('agents',{}).get('list',[])]" 2>/dev/null; then
    pass "Agent: $agent"
  else
    fail "Agent missing: $agent"
  fi
done

echo ""

# --- Workspaces ---
echo "Workspaces:"
for ws in workspace-bsi-figma-mcp workspace-bsi-figma-executor workspace-bsi-webflow-mcp workspace-bsi-webflow-executor workspace-bsi-shopify-mcp workspace-bsi-shopify-executor; do
  if [[ -d "$HOME/.openclaw/$ws" ]]; then
    pass "$ws"
  else
    fail "$ws missing"
  fi
done

echo ""
echo "============================================"
echo -e "${GREEN}[OK] Verification complete.${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart OpenClaw: openclaw gateway restart"
echo "  2. Open Figma Desktop and import the plugin"
echo "  3. Test: openclaw agent bsi-figma-mcp"
