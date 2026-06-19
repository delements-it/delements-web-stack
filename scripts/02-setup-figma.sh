#!/usr/bin/env bash
# ============================================================================
# 02-setup-figma.sh - Setup Figma MCP server and plugin
# ============================================================================
set -euo pipefail

FIGMA_MCP_DIR="${FIGMA_MCP_DIR:-$HOME/Documents/WORKSPACES/AI Coding Tools/figma-mcp-server}"
FIGMA_MCP_REPO="${FIGMA_MCP_REPO:-https://github.com/figma/figma-mcp-server.git}"

echo "🎨 Setting up Figma MCP..."
echo "  Install dir: $FIGMA_MCP_DIR"

# Install tsx (required for Figma MCP)
if ! command -v tsx &> /dev/null; then
  echo "  Installing tsx (required for Figma MCP)..."
  npm install -g tsx
fi

# Clone or update Figma MCP server
if [ -d "$FIGMA_MCP_DIR" ]; then
  echo "  Figma MCP already exists, updating..."
  cd "$FIGMA_MCP_DIR"
  git pull
else
  echo "  Cloning Figma MCP server..."
  mkdir -p "$(dirname "$FIGMA_MCP_DIR")"
  git clone "$FIGMA_MCP_REPO" "$FIGMA_MCP_DIR"
fi

# Install dependencies
echo "  Installing dependencies..."
cd "$FIGMA_MCP_DIR/mcp"
npm install

# Build plugin
echo "  Building Figma plugin..."
cd "$FIGMA_MCP_DIR/plugin"
npm install
npm run build

echo "✅ Figma MCP setup complete"
echo "  Server: $FIGMA_MCP_DIR/mcp"
echo "  Plugin: $FIGMA_MCP_DIR/plugin"
