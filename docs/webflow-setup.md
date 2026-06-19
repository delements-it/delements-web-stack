# Webflow Setup Guide

## Prerequisites

- Webflow account with site access
- Node.js ≥ 20

## Installation

```bash
make webflow
```

This will:
1. Add Webflow MCP config to `openclaw.json`
2. Setup mcporter OAuth config
3. Validate token (if provided)

## Configuration

### Environment Variables

Add to `env/.env`:

```bash
WEBFLOW_TOKEN=***
```

**Getting your Webflow token**:
1. Go to Webflow Dashboard
2. **Settings** → **API** → **Generate API token**
3. Copy the token

### MCP Server Config

Auto-injected into `~/.openclaw/openclaw.json`:

```json
{
  "mcp": {
    "servers": {
      "webflow": {
        "command": "npx",
        "args": ["-y", "webflow-mcp-server"],
        "env": {
          "WEBFLOW_TOKEN": "***"
        }
      }
    }
  }
}
```

### mcporter OAuth Config (Alternative)

Auto-created at `~/.openclaw/workspace/config/mcporter.json`:

```json
{
  "mcpServers": {
    "webflow": {
      "baseUrl": "https://mcp.webflow.com/mcp",
      "auth": "oauth"
    }
  }
}
```

## Usage

### Available Operations

**Sites**:
- `webflow__sites_list` — List all accessible sites
- `webflow__sites_get` — Get site details
- `webflow__sites_publish` — Publish a site
- `webflow__pages_list` — List pages in a site
- `webflow__pages_get_metadata` — Get page SEO/metadata
- `webflow__pages_update_page_settings` — Update page settings

**CMS**:
- `webflow__collections_list` — List CMS collections
- `webflow__collections_get` — Get collection schema
- `webflow__collections_items_list_items` — List CMS items
- `webflow__collections_items_create_item` — Create CMS item (draft)
- `webflow__collections_items_create_item_live` — Create and publish
- `webflow__collections_items_update_items` — Update items
- `webflow__collections_items_delete_item` — Delete item

**Designer Tools** (requires Webflow Designer):
- `webflow__element_builder` — Create elements
- `webflow__element_tool` — Modify elements
- `webflow__style_tool` — Manage styles
- `webflow__variable_tool` — Manage variables
- `webflow__de_component_tool` — Component operations

**Assets**:
- `webflow__asset_tool` — Manage assets and folders

### Testing

```bash
# List your Webflow sites
openclaw agent bsi-webflow-mcp
# Ask: "List all my Webflow sites"
```

## Troubleshooting

### Token not working

- Verify token in Webflow Dashboard → Settings → API
- Ensure token has correct scopes (read/write)
- Check token hasn't expired

### OAuth flow not completing

- Run `mcporter auth webflow` manually
- Check browser popup for OAuth consent
- Verify mcporter config in `config/mcporter.json`

### MCP server errors

- Restart OpenClaw gateway: `openclaw gateway restart`
- Check `npx -y webflow-mcp-server` runs without errors
- Verify WEBFLOW_TOKEN is set in openclaw.json

### Designer tools not available

- Designer tools require Webflow Designer app (not browser)
- Ensure you're logged into Webflow Designer
- Some tools only work on published sites

## Updates

Webflow MCP server updates automatically via npx:

```bash
# Force update
npx -y webflow-mcp-server@latest
```

Then restart OpenClaw gateway.
