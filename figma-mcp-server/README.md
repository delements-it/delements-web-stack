# Figma MCP Server

This directory contains patches and documentation for the [Figma MCP Server](https://github.com/Antonytm/figma-mcp-server).

## Original Repository

- **Source**: https://github.com/Antonytm/figma-mcp-server
- **Version**: 0.2.0
- **License**: ISC

## Installation

The setup script (`scripts/02-setup-figma.sh`) will:

1. Clone the repo to `~/Documents/HH/figma-mcp-server`
2. Install MCP server dependencies (`mcp/` directory)
3. Install plugin dependencies (`plugin/` directory)
4. Build the Figma plugin

## Patches

Currently no patches applied. If you need to modify the MCP server or plugin:

1. Make changes in `~/Documents/HH/figma-mcp-server`
2. Create a patch file: `git diff > patches/your-patch.patch`
3. Apply in setup script if needed

## Architecture

```
Figma Desktop
    ↕ (Plugin API)
Figma Plugin (React)
    ↕ (WebSocket on port 38450)
MCP Server (Node.js)
    ↕ (stdio)
OpenClaw Agent
```

## Key Files

- `mcp/src/index.ts` — MCP server entry point
- `mcp/src/tools/` — Tool implementations
- `plugin/main/code.ts` — Plugin main code
- `plugin/ui/` — Plugin UI (React)
- `plugin/manifest.json` — Plugin manifest

## Notes

- Plugin must be running in Figma Desktop for MCP tools to work
- WebSocket communication on localhost:38450
- Supports both Figma and FigJam files
- 23 tools available (create, read, update, delete operations)
