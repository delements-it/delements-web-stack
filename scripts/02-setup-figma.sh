#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 02-setup-figma.sh — Clone & build Figma MCP server + plugin
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "  ${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; }

# Load env
ENV_FILE="env/.env"
if [[ -f "$ENV_FILE" ]]; then
  set -a; source "$ENV_FILE"; set +a
fi

FIGMA_MCP_REPO="${FIGMA_MCP_REPO:-https://github.com/Antonytm/figma-mcp-server.git}"
FIGMA_MCP_DIR="${FIGMA_MCP_DIR:-$HOME/Documents/WORKSPACES/AI Coding Tools/figma-mcp-server}"

echo "Setting up Figma MCP..."
echo ""

# --- Clone repo ---
if [[ -d "$FIGMA_MCP_DIR/.git" ]]; then
  info "Figma MCP repo already exists at $FIGMA_MCP_DIR"
else
  info "Cloning Figma MCP server..."
  mkdir -p "$(dirname "$FIGMA_MCP_DIR")"
  git clone "$FIGMA_MCP_REPO" "$FIGMA_MCP_DIR"
  info "Cloned to $FIGMA_MCP_DIR"
fi

# --- Install MCP server dependencies ---
if [[ -d "$FIGMA_MCP_DIR/mcp/node_modules" ]]; then
  info "MCP server dependencies already installed"
else
  info "Installing MCP server dependencies..."
  cd "$FIGMA_MCP_DIR/mcp"
  npm install
  cd - >/dev/null
fi

# --- Install plugin dependencies ---
if [[ -d "$FIGMA_MCP_DIR/plugin/node_modules" ]]; then
  info "Plugin dependencies already installed"
else
  info "Installing plugin dependencies..."
  cd "$FIGMA_MCP_DIR/plugin"
  npm install
  cd - >/dev/null
fi

# --- Build plugin ---
if [[ -f "$FIGMA_MCP_DIR/plugin/dist/main.js" ]]; then
  info "Plugin already built"
else
  info "Building Figma plugin..."
  cd "$FIGMA_MCP_DIR/plugin"
  npm run build
  cd - >/dev/null
fi

# --- Register plugin in Figma ---
info "Plugin manifest: $FIGMA_MCP_DIR/plugin/manifest.json"
info "Manual step: Add this plugin in Figma Desktop:"
info "   Figma → Plugins → Development → Import plugin from manifest"
info "   Select: $FIGMA_MCP_DIR/plugin/manifest.json"

# --- Inject MCP config into openclaw.json ---
OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"
if [[ -f "$OPENCLAW_JSON" ]]; then
  if python3 -c "import json; d=json.load(open('$OPENCLAW_JSON')); assert 'figma' in d.get('mcp',{}).get('servers',{})" 2>/dev/null; then
    info "Figma MCP already configured in openclaw.json"
  else
    info "Adding Figma MCP to openclaw.json..."
    python3 -c "
import json
with open('$OPENCLAW_JSON', 'r') as f:
    config = json.load(f)
if 'mcp' not in config:
    config['mcp'] = {'servers': {}}
config['mcp']['servers']['figma'] = {
    'command': 'npx',
    'args': ['tsx', 'src/index.ts'],
    'env': {'TRANSPORT': 'stdio'},
    'cwd': '$FIGMA_MCP_DIR/mcp'
}
with open('$OPENCLAW_JSON', 'w') as f:
    json.dump(config, f, indent=2)
print('  Added figma MCP server entry')
"
  fi
else
  warn "openclaw.json not found - run OpenClaw setup first"
fi

echo ""
echo -e "${GREEN}[OK] Figma MCP setup complete.${NC}"
echo "  MCP Server: $FIGMA_MCP_DIR/mcp"
echo "  Plugin:     $FIGMA_MCP_DIR/plugin"
echo "  Transport:  stdio"
echo "  Remember to open the plugin in Figma Desktop before using tools."
