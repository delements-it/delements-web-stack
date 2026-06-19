#!/usr/bin/env bash
# ============================================================================
# 07-setup-auth.sh - Setup OpenClaw auth profiles
# ============================================================================
set -euo pipefail

OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"

echo "🔐 Setting up auth profiles..."
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

if 'auth' not in config:
    config['auth'] = {}
if 'profiles' not in config['auth']:
    config['auth']['profiles'] = {}

profiles = config['auth']['profiles']

# Ollama (local)
if 'ollama:default' not in profiles:
    profiles['ollama:default'] = {
        'provider': 'ollama',
        'mode': 'api_key'
    }
    print("  ✅ Added ollama:default")
else:
    print("  ✓ ollama:default already exists")

# OpenAI
if 'openai:default' not in profiles:
    profiles['openai:default'] = {
        'provider': 'openai',
        'mode': 'oauth'
    }
    print("  ✅ Added openai:default")
else:
    print("  ✓ openai:default already exists")

# Qwen
if 'qwen:default' not in profiles:
    profiles['qwen:default'] = {
        'provider': 'qwen',
        'mode': 'api_key'
    }
    print("  ✅ Added qwen:default")
else:
    print("  ✓ qwen:default already exists")

with open(openclaw_json, 'w') as f:
    json.dump(config, f, indent=2)

print("\n✅ Auth profiles configured")
print("\nNext steps:")
print("  - Ollama: Start with 'ollama serve'")
print("  - OpenAI: Run 'openclaw auth login --provider openai'")
print("  - Qwen: Set QWEN_API_KEY in environment")
PYEOF
