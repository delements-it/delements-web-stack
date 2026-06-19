# Figma Setup Guide

## Prerequisites

- Figma Desktop app installed ([download](https://www.figma.com/downloads/))
- Figma account with design file access
- Node.js ≥ 20

## Installation

```bash
make figma
```

This will:
1. Clone `figma-mcp-server` to `$FIGMA_MCP_DIR`
2. Install MCP server dependencies
3. Install plugin dependencies
4. Build the plugin
5. Add MCP config to `openclaw.json`

## Manual Plugin Setup

After running `make figma`, you must manually import the plugin into Figma Desktop:

1. Open Figma Desktop
2. Go to **Plugins** → **Development** → **Import plugin from manifest...**
3. Select: `$FIGMA_MCP_DIR/plugin/manifest.json`
4. The plugin will appear in your Development plugins list

## Configuration

### Environment Variables

Add to `env/.env`:

```bash
FIGMA_USER_ID=your_figma_user_id
FIGMA_MCP_REPO=https://github.com/Antonytm/figma-mcp-server.git
FIGMA_MCP_DIR=$HOME/Documents/WORKSPACES/AI Coding Tools/figma-mcp-server
```

**Finding your Figma User ID**:
- Open Figma Desktop
- Click your profile picture
- Your user ID appears in the URL: `figma.com/files/user/YOUR_ID`

### MCP Server Config

Auto-injected into `~/.openclaw/openclaw.json`:

```json
{
  "mcp": {
    "servers": {
      "figma": {
        "command": "npx",
        "args": ["tsx", "src/index.ts"],
        "env": { "TRANSPORT": "stdio" },
        "cwd": "$FIGMA_MCP_DIR/mcp"
      }
    }
  }
}
```

## Usage

### Before Using Tools

⚠️ **The Figma plugin MUST be open** for any MCP tools to work:

1. Open Figma Desktop
2. Open a design file
3. Run the plugin: **Plugins** → **Development** → **Figma MCP Server**
4. The plugin window will show "Connected" when ready

### Available Tools (23 total)

**Create**:
- `createRectangle` — Create a rectangle node
- `createFrame` — Create a frame
- `createText` — Create a text node
- `createInstance` — Create a component instance
- `createComponent` — Create a new component
- `createImage` — Create an image node
- `cloneNode` — Clone an existing node
- `addComponentProperty` — Add a property to a component
- `addPrototypeLink` — Add a prototype interaction

**Read**:
- `getSelection` — Get currently selected nodes
- `getNodeInfo` — Get detailed node information
- `getAllComponents` — List all components in the file
- `getPages` — List all pages

**Update**:
- `moveNode` — Move a node
- `resizeNode` — Resize a node
- `setFillColor` — Set fill color
- `setStrokeColor` — Set stroke color
- `setCornerRadius` — Set corner radius
- `setLayout` — Set auto-layout properties
- `editComponentProperty` — Edit component property
- `setInstanceProperties` — Set instance overrides
- `setParentId` — Reparent a node
- `setNodeComponentPropertyReferences` — Set property references

**Delete**:
- `deleteNode` — Delete a node
- `deleteComponentProperty` — Delete a component property

### Testing

```bash
# Verify MCP server is running
openclaw agent bsi-figma-mcp
# Ask: "Run _whoami to check Figma MCP connectivity"
```

## Troubleshooting

### Plugin not connecting

- Ensure the plugin window is open in Figma Desktop
- Check that Figma Desktop is running (not web version)
- Verify the MCP server is running: `ps aux | grep figma-mcp`

### MCP tools not appearing

- Restart OpenClaw gateway: `openclaw gateway restart`
- Check `openclaw.json` has the figma MCP entry
- Verify plugin manifest path is correct

### WebSocket errors

- Plugin must be running on port 38450
- Check for port conflicts: `lsof -i :38450`
- Rebuild plugin: `cd "$FIGMA_MCP_DIR/plugin" && npm run build`

## Updates

To update the Figma MCP server:

```bash
cd "$FIGMA_MCP_DIR"
git pull
cd mcp && npm install
cd ../plugin && npm install && npm run build
```

Then restart OpenClaw gateway.
