# TOOLS.md - BSI | Shopify MCP Local Notes

## Shopify MCP Server

**Config**: `openclaw.json` → `mcp.servers.shopify`
**Transport**: `npx shopify-mcp`
**Auth**: Admin API access token

## Shopify Dev MCP

**Config**: `openclaw.json` → `mcp.servers.shopify-dev-mcp`
**Transport**: `npx @shopify/dev-mcp@latest`
**Purpose**: Docs, schema, validation, code generation

## Shopify CLI

**Installed**: `@shopify/cli` (global npm)
**Purpose**: Live store auth, theme dev, Admin GraphQL

### Available Operations
- Products: CRUD, variants, options
- Orders: list, get, update, fulfill
- Customers: list, get, update
- Themes: list, pull, push, dev, publish
- GraphQL: Admin API queries/mutations
- Store auth: `shopify auth login`

### Run Profiles
- `docs-schema`: Docs/validation only, no live store
- `read-live`: Read-only live queries
- `mutation-approved`: Live mutations (requires approval)
- `theme-dev`: Theme development (preview)
- `theme-publish`: Live theme publish (blocked by default)
- `integration-governance`: System mapping/analysis
