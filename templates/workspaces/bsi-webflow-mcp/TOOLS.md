# TOOLS.md - BSI | Webflow MCP Local Notes

## Webflow MCP Server

**Config**: `openclaw.json` → `mcp.servers.webflow`
**Transport**: `npx -y webflow-mcp-server`
**Auth**: OAuth via mcporter or token-based

### Available Tools
- Sites: list, get, publish
- Pages: list, get metadata, get content, update settings
- CMS: collections CRUD, items CRUD, fields CRUD
- Components: list, get content/properties, update
- Designer: element builder, style tool, variable tool, component tool
- Assets: folder management, asset CRUD

### Auth Methods
1. **Token-based**: `WEBFLOW_TOKEN` env var in openclaw.json
2. **OAuth**: via mcporter config (`config/mcporter.json`)
