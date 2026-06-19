#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 05-configure-agents.sh — Setup BSI agents in OpenClaw
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "  ${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; }

OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"

echo "Configuring BSI agents..."
echo ""

if [[ ! -f "$OPENCLAW_JSON" ]]; then
  warn "openclaw.json not found - run OpenClaw setup first"
  exit 1
fi

# --- Add BSI agents to openclaw.json ---
OPENCLAW_JSON="$OPENCLAW_JSON" HOME="$HOME" python3 << 'PYEOF'
import json
import os

home = os.environ["HOME"]
openclaw_json = os.environ["OPENCLAW_JSON"]

with open(openclaw_json, 'r') as f:
    config = json.load(f)

if 'agents' not in config:
    config['agents'] = {'list': []}

existing_ids = {a['id'] for a in config['agents']['list']}

bsi_agents = [
    {
        "id": "bsi-figma-mcp",
        "name": "bsi-figma-mcp",
        "workspace": f"{home}/.openclaw/workspace-bsi-figma-mcp",
        "agentDir": f"{home}/.openclaw/agents/bsi-figma-mcp/agent",
        "identity": {
            "name": "BSI | Figma MCP",
            "emoji": "🎨"
        }
    },
    {
        "id": "bsi-figma-executor",
        "name": "BSI | Figma Executor",
        "workspace": f"{home}/.openclaw/workspace-bsi-figma-executor",
        "agentDir": f"{home}/.openclaw/agents/bsi-figma-executor/agent"
    },
    {
        "id": "bsi-webflow-mcp",
        "name": "BSI | Webflow MCP",
        "workspace": f"{home}/.openclaw/workspace-bsi-webflow-mcp",
        "agentDir": f"{home}/.openclaw/agents/bsi-webflow-mcp/agent",
        "identity": {
            "name": "BSI | Webflow MCP",
            "emoji": "🌐"
        }
    },
    {
        "id": "bsi-webflow-executor",
        "name": "BSI | Webflow Executor",
        "workspace": f"{home}/.openclaw/workspace-bsi-webflow-executor",
        "agentDir": f"{home}/.openclaw/agents/bsi-webflow-executor/agent"
    },
    {
        "id": "bsi-shopify-mcp",
        "name": "BSI | Shopify MCP",
        "workspace": f"{home}/.openclaw/workspace-bsi-shopify-mcp",
        "agentDir": f"{home}/.openclaw/agents/bsi-shopify-mcp/agent",
        "identity": {
            "name": "BSI | Shopify MCP",
            "emoji": "🛒"
        }
    },
    {
        "id": "bsi-shopify-executor",
        "name": "BSI | Shopify Executor",
        "workspace": f"{home}/.openclaw/workspace-bsi-shopify-executor",
        "agentDir": f"{home}/.openclaw/agents/bsi-shopify-executor/agent"
    }
]

added = 0
for agent in bsi_agents:
    if agent['id'] not in existing_ids:
        config['agents']['list'].append(agent)
        print(f"  Added agent: {agent['id']}")
        added += 1
    else:
        print(f"  Agent already exists: {agent['id']}")

with open(openclaw_json, 'w') as f:
    json.dump(config, f, indent=2)

if added > 0:
    print(f"\n  [OK] Added {added} BSI agent(s)")
else:
    print(f"\n  [OK] All BSI agents already configured")
PYEOF

# --- Create workspace directories ---
info "Creating workspace directories..."
WORKSPACES=(
  "$HOME/.openclaw/workspace-bsi-figma-mcp"
  "$HOME/.openclaw/workspace-bsi-figma-executor"
  "$HOME/.openclaw/workspace-bsi-webflow-mcp"
  "$HOME/.openclaw/workspace-bsi-webflow-executor"
  "$HOME/.openclaw/workspace-bsi-shopify-mcp"
  "$HOME/.openclaw/workspace-bsi-shopify-executor"
)

for ws in "${WORKSPACES[@]}"; do
  if [[ ! -d "$ws" ]]; then
    mkdir -p "$ws"
    info "Created: $ws"
  fi
done

# --- Copy workspace templates ---
info "Copying workspace templates..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

copy_template() {
  local agent_id=$1
  local ws_name=$2
  local ws_dir="$HOME/.openclaw/workspace-$ws_name"
  local template_dir="$REPO_ROOT/templates/workspaces/$ws_name"
  
  if [[ -d "$template_dir" ]]; then
    for file in AGENTS.md SOUL.md TOOLS.md IDENTITY.md HEARTBEAT.md USER.md; do
      if [[ -f "$template_dir/$file" ]] && [[ ! -f "$ws_dir/$file" ]]; then
        cp "$template_dir/$file" "$ws_dir/$file"
      fi
    done
  fi
}

copy_template "bsi-figma-mcp" "bsi-figma-mcp"
copy_template "bsi-figma-executor" "bsi-figma-executor"
copy_template "bsi-webflow-mcp" "bsi-webflow-mcp"
copy_template "bsi-webflow-executor" "bsi-webflow-executor"
copy_template "bsi-shopify-mcp" "bsi-shopify-mcp"
copy_template "bsi-shopify-executor" "bsi-shopify-executor"

echo ""
echo -e "${GREEN}[OK] BSI agents configured.${NC}"
echo "  6 agents added to openclaw.json"
echo "  Workspaces created in ~/.openclaw/"
