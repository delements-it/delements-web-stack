#!/bin/bash
# Install skills for OpenClaw and Codex

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Installing Skills ==="

# OpenClaw skills
echo "📦 Installing OpenClaw skills..."
OPENCLAW_SKILLS_DIR="${OPENCLAW_HOME:-$HOME/.openclaw}/plugin-skills"
mkdir -p "$OPENCLAW_SKILLS_DIR"

for skill in "$REPO_ROOT/skills/openclaw"/*; do
    if [ -d "$skill" ]; then
        skill_name=$(basename "$skill")
        echo "  → $skill_name"
        rm -rf "$OPENCLAW_SKILLS_DIR/$skill_name"
        cp -R "$skill" "$OPENCLAW_SKILLS_DIR/"
    fi
done

# Codex skills
echo "📦 Installing Codex skills..."
CODEX_SKILLS_DIR="$HOME/.codex/skills"
mkdir -p "$CODEX_SKILLS_DIR"

for skill in "$REPO_ROOT/skills/codex"/*; do
    if [ -d "$skill" ]; then
        skill_name=$(basename "$skill")
        echo "  → $skill_name"
        rm -rf "$CODEX_SKILLS_DIR/$skill_name"
        cp -R "$skill" "$CODEX_SKILLS_DIR/"
    fi
done

echo ""
echo "✅ Skills installed successfully!"
echo ""
echo "OpenClaw skills: $(ls -1 "$OPENCLAW_SKILLS_DIR" | wc -l) total"
echo "Codex skills: $(ls -1 "$CODEX_SKILLS_DIR" | wc -l) total"
