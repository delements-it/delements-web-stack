#!/usr/bin/env bash
# ============================================================================
# 08-setup-plugins.sh - Setup OpenClaw plugins
# ============================================================================
set -euo pipefail

OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"

echo "🔌 Setting up plugins..."
echo ""

if [[ ! -f "$OPENCLAW_JSON" ]]; then
  echo "❌ openclaw.json not found - run OpenClaw setup first"
  exit 1
fi

OPENCLAW_JSON="$OPENCLAW_JSON" HOME="$HOME" python3 << 'PYEOF'
import json
import os

home = os.environ["HOME"]
openclaw_json = os.environ["OPENCLAW_JSON"]

with open(openclaw_json, 'r') as f:
    config = json.load(f)

if 'plugins' not in config:
    config['plugins'] = {}
if 'allow' not in config['plugins']:
    config['plugins']['allow'] = []

plugins = config['plugins']['allow']

# Required plugins for web stack
required = [
    'bonjour',
    'browser',
    'canvas',
    'codex',
    'device-pair',
    'file-transfer',
    'github-copilot',
    'google',
    'memory-core',
    'ollama',
    'openai',
    'qwen',
    'workboard'
]

added = []
for plugin in required:
    if plugin not in plugins:
        plugins.append(plugin)
        added.append(plugin)
        print(f"  ✅ Added {plugin}")
    else:
        print(f"  ✓ {plugin} already enabled")

if added:
    print(f"\n✅ Added {len(added)} plugin(s)")
else:
    print("\n✅ All plugins already enabled")

with open(openclaw_json, 'w') as f:
    json.dump(config, f, indent=2)

print("\nRestart OpenClaw to apply: openclaw restart")
PYEOF
