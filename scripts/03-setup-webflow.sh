#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 03-setup-webflow.sh — Configure Webflow MCP
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "  ${GREEN}ℹ️${NC}  $1" }
warn() { echo -e "  ${YELLOW}⚠️${NC}  $1" }

# Load env
ENV_FILE="env/.env"
if [[ -f "$ENV_FILE" ]]; then
  set -a; source "$ENV_FILE"; set +a
fi

WEBFLOW_TOKEN="${WEBFLOW_TOKEN:-}"

echo "🌐 Setting up Webflow MCP..."
echo ""

# --- Check token ---
if [[ -z "$WEBFLOW_TOKEN" ]]; then
  warn "WEBFLOW_TOKEN not set in env/.env"
  warn "Get your token: Webflow → Settings → API → Generate token"
  warn "Continuing without token — you'll need to add it later."
fi

# --- Inject MCP config into openclaw.json ---
OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"
if [[ -f "$OPENCLAW_JSON" ]]; then
  if python3 -c "import json; d=json.load(open('$OPENCLAW_JSON')); assert 'webflow' in d.get('mcp',{}).get('servers',{})" 2>/dev/null; then
    info "Webflow MCP already configured in openclaw.json"
  else
    info "Adding Webflow MCP to openclaw.json..."
    python3 -c "
import json
with open('$OPENCLAW_JSON', 'r') as f:
    config = json.load(f)
if 'mcp' not in config:
    config['mcp'] = {'servers': {}}
config['mcp']['servers']['webflow'] = {
    'command': 'npx',
    'args': ['-y', 'webflow-mcp-server'],
    'env': {'WEBFLOW_TOKEN': '$WEBFLOW_TOKEN'}
}
with open('$OPENCLAW_JSON', 'w') as f:
    json.dump(config, f, indent=2)
print('  Added webflow MCP server entry')
"
  fi
else
  warn "openclaw.json not found — run OpenClaw setup first"
fi

# --- Setup mcporter config (OAuth alternative) ---
MCPORTER_DIR="$HOME/.openclaw/workspace/config"
MCPORTER_JSON="$MCPORTER_DIR/mcporter.json"
if [[ -f "$MCPORTER_JSON" ]]; then
  if python3 -c "import json; d=json.load(open('$MCPORTER_JSON')); assert 'webflow' in d.get('mcpServers',{})" 2>/dev/null; then
    info "mcporter Webflow config already exists"
  else
    info "Adding Webflow to mcporter config..."
    mkdir -p "$MCPORTER_DIR"
    python3 -c "
import json
with open('$MCPORTER_JSON', 'r') as f:
    config = json.load(f)
if 'mcpServers' not in config:
    config['mcpServers'] = {}
config['mcpServers']['webflow'] = {
    'baseUrl': 'https://mcp.webflow.com/mcp',
    'auth': 'oauth'
}
with open('$MCPORTER_JSON', 'w') as f:
    json.dump(config, f, indent=2)
print('  Added webflow mcporter entry')
"
  fi
else
  info "Creating mcporter config..."
  mkdir -p "$MCPORTER_DIR"
  cat > "$MCPORTER_JSON" << 'MCPJSON'
{
  "mcpServers": {
    "webflow": {
      "baseUrl": "https://mcp.webflow.com/mcp",
      "auth": "oauth"
    }
  }
}
MCPJSON
fi

echo ""
echo -e "${GREEN}✅ Webflow MCP setup complete.${NC}"
echo "  MCP Server: npx -y webflow-mcp-server"
echo "  mcporter:   OAuth via https://mcp.webflow.com/mcp"
