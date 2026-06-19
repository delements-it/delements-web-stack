#!/usr/bin/env bash
# =============================================================================
# 11-setup-notebooklm.sh
# Setup NotebookLM MCP Server integration with Antigravity (OpenClaw + Codex)
# =============================================================================

set -euo pipefail

echo "=== NotebookLM MCP Server Setup ==="
echo ""

# Check if already installed
if command -v notebooklm-mcp &> /dev/null; then
    echo "✅ notebooklm-mcp already installed: $(notebooklm-mcp --version)"
else
    echo "📦 Installing notebooklm-mcp@latest..."
    npm install -g notebooklm-mcp@latest
fi

# Check Chrome profile exists
CHROME_PROFILE_DIR="$HOME/Library/Application Support/notebooklm-mcp/chrome_profile"
if [ -d "$CHROME_PROFILE_DIR" ]; then
    echo "✅ Chrome profile exists at: $CHROME_PROFILE_DIR"
else
    echo "⚠️  Chrome profile not found. You'll need to run setup_auth on first use."
fi

# Check library.json
LIBRARY_FILE="$HOME/Library/Application Support/notebooklm-mcp/library.json"
if [ -f "$LIBRARY_FILE" ]; then
    echo "✅ Library exists at: $LIBRARY_FILE"
else
    echo "ℹ️  Library not found. Will be created on first use."
fi

echo ""
echo "=== Configuration ==="

# Update OpenClaw config
OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"
if [ -f "$OPENCLAW_CONFIG" ]; then
    if grep -q '"notebooklm"' "$OPENCLAW_CONFIG"; then
        echo "✅ NotebookLM already in OpenClaw config"
    else
        echo "📝 Adding NotebookLM to OpenClaw config..."
        # Use jq if available, otherwise use node
        if command -v jq &> /dev/null; then
            jq '.mcp.servers.notebooklm = {
                "command": "npx",
                "args": ["notebooklm-mcp@latest"],
                "env": {
                    "HEADLESS": "true",
                    "NOTEBOOKLM_PROFILE": "standard",
                    "NOTEBOOKLM_AI_MARKER": "true",
                    "MAX_SESSIONS": "5",
                    "SESSION_TIMEOUT": "900"
                }
            }' "$OPENCLAW_CONFIG" > "$OPENCLAW_CONFIG.tmp" && mv "$OPENCLAW_CONFIG.tmp" "$OPENCLAW_CONFIG"
        else
            node -e "
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('$OPENCLAW_CONFIG', 'utf8'));
config.mcp.servers.notebooklm = {
    command: 'npx',
    args: ['notebooklm-mcp@latest'],
    env: {
        HEADLESS: 'true',
        NOTEBOOKLM_PROFILE: 'standard',
        NOTEBOOKLM_AI_MARKER: 'true',
        MAX_SESSIONS: '5',
        SESSION_TIMEOUT: '900'
    }
};
fs.writeFileSync('$OPENCLAW_CONFIG', JSON.stringify(config, null, 2));
"
        fi
        echo "✅ Added to OpenClaw config"
    fi
fi

# Update Codex config
CODEX_CONFIG="$HOME/.codex/config.toml"
if [ -f "$CODEX_CONFIG" ]; then
    if grep -q 'mcp_servers.notebooklm' "$CODEX_CONFIG"; then
        echo "✅ NotebookLM already in Codex config"
    else
        echo "📝 Adding NotebookLM to Codex config..."
        cat >> "$CODEX_CONFIG" << 'EOF'

[mcp_servers.notebooklm]
command = "npx"
args = ["notebooklm-mcp@latest"]
startup_timeout_sec = 60

[mcp_servers.notebooklm.env]
HEADLESS = "true"
NOTEBOOKLM_PROFILE = "standard"
NOTEBOOKLM_AI_MARKER = "true"
MAX_SESSIONS = "5"
SESSION_TIMEOUT = "900"
EOF
        echo "✅ Added to Codex config"
    fi
fi

echo ""
echo "=== Next Steps ==="
echo "1. Restart OpenClaw/Codex to load NotebookLM MCP"
echo "2. On first use, call setup_auth tool to login to Google"
echo "3. Add notebooks using add_notebook tool"
echo "4. Query with ask_question tool"
echo ""
echo "=== Verification ==="
echo "Run: notebooklm-mcp --version"
echo "Should show: NotebookLM MCP Server v2.0.0"
echo ""
echo "✅ Setup complete!"
