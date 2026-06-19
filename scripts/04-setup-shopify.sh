#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 04-setup-shopify.sh — Install Shopify CLI + configure MCP servers
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

SHOPIFY_ACCESS_TOKEN="${SHOPIFY_ACCESS_TOKEN:-}"
SHOPIFY_DOMAIN="${SHOPIFY_DOMAIN:-your-store.myshopify.com}"

echo "Setting up Shopify..."
echo ""

# --- Install Shopify CLI ---
if command -v shopify &>/dev/null; then
  info "Shopify CLI already installed: $(shopify version 2>/dev/null || echo 'unknown')"
else
  info "Installing Shopify CLI..."
  npm install -g @shopify/cli
  info "Shopify CLI installed: $(shopify version 2>/dev/null || echo 'done')"
fi

# --- Check token ---
if [[ -z "$SHOPIFY_ACCESS_TOKEN" ]]; then
  warn "SHOPIFY_ACCESS_TOKEN not set in env/.env"
  warn "Get your token: Shopify Admin → Apps → Develop apps → Admin API access"
  warn "Continuing without token - you'll need to add it later."
fi

# --- Inject MCP configs into openclaw.json ---
OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"
if [[ -f "$OPENCLAW_JSON" ]]; then
  python3 -c "
import json
with open('$OPENCLAW_JSON', 'r') as f:
    config = json.load(f)
if 'mcp' not in config:
    config['mcp'] = {'servers': {}}

# Shopify MCP (Admin API)
if 'shopify' not in config['mcp']['servers']:
    config['mcp']['servers']['shopify'] = {
        'command': 'npx',
        'args': [
            'shopify-mcp',
            '--accessToken', '$SHOPIFY_ACCESS_TOKEN',
            '--domain', '$SHOPIFY_DOMAIN'
        ]
    }
    print('  Added shopify MCP server entry')
else:
    print('  Shopify MCP already configured')

# Shopify Dev MCP (docs/schema/validation)
if 'shopify-dev-mcp' not in config['mcp']['servers']:
    config['mcp']['servers']['shopify-dev-mcp'] = {
        'command': 'npx',
        'args': ['-y', '@shopify/dev-mcp@latest']
    }
    print('  Added shopify-dev-mcp server entry')
else:
    print('  Shopify Dev MCP already configured')

with open('$OPENCLAW_JSON', 'w') as f:
    json.dump(config, f, indent=2)
"
else
  warn "openclaw.json not found - run OpenClaw setup first"
fi

echo ""
echo -e "${GREEN}[OK] Shopify setup complete.${NC}"
echo "  CLI:          shopify $(shopify version 2>/dev/null || echo 'installed')"
echo "  MCP (Admin):  npx shopify-mcp"
echo "  MCP (Dev):    npx @shopify/dev-mcp@latest"
echo "  Store:        $SHOPIFY_DOMAIN"
