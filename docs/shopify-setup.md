# Shopify Setup Guide

## Prerequisites

- Shopify store with Admin API access
- Node.js ≥ 20

## Installation

```bash
make shopify
```

This will:
1. Install Shopify CLI globally
2. Add Shopify MCP configs to `openclaw.json`
3. Add Shopify Dev MCP config

## Configuration

### Environment Variables

Add to `env/.env`:

```bash
SHOPIFY_ACCESS_TOKEN=***
SHOPIFY_DOMAIN=your-store.myshopify.com
```

**Getting your Shopify access token**:
1. Go to Shopify Admin
2. **Apps** → **Develop apps** → **Create an app**
3. **Configure Admin API scopes** (products, orders, customers, etc.)
4. **Install app** → Copy the Admin API access token

### MCP Server Configs

Auto-injected into `~/.openclaw/openclaw.json`:

**Shopify MCP** (Admin API access):
```json
{
  "mcp": {
    "servers": {
      "shopify": {
        "command": "npx",
        "args": [
          "shopify-mcp",
          "--accessToken", "***",
          "--domain", "your-store.myshopify.com"
        ]
      }
    }
  }
}
```

**Shopify Dev MCP** (docs/schema/validation):
```json
{
  "mcp": {
    "servers": {
      "shopify-dev-mcp": {
        "command": "npx",
        "args": ["-y", "@shopify/dev-mcp@latest"]
      }
    }
  }
}
```

## Usage

### Shopify CLI

```bash
# Login to store
shopify auth login --store your-store.myshopify.com

# List themes
shopify theme list

# Pull theme
shopify theme pull --theme-editor-sync

# Dev server
shopify theme dev

# Push theme
shopify theme push
```

### MCP Tools

**Products**:
- `shopify__get-products` — List products
- `shopify__get-product-by-id` — Get product details
- `shopify__create-product` — Create product
- `shopify__update-product` — Update product
- `shopify__delete-product` — Delete product
- `shopify__manage-product-variants` — Manage variants
- `shopify__manage-product-options` — Manage options

**Orders**:
- `shopify__get-orders` — List orders
- `shopify__get-order-by-id` — Get order details
- `shopify__update-order` — Update order

**Customers**:
- `shopify__get-customers` — List customers
- `shopify__get-customer-orders` — Get customer orders
- `shopify__update-customer` — Update customer

**Dev MCP** (docs/validation):
- `shopify-dev-mcp__learn_shopify_api` — Learn about APIs
- `shopify-dev-mcp__search_docs_chunks` — Search docs
- `shopify-dev-mcp__validate_graphql_codeblocks` — Validate GraphQL
- `shopify-dev-mcp__validate_component_codeblocks` — Validate components
- `shopify-dev-mcp__validate_theme` — Validate Liquid/theme code

### Run Profiles

Shopify operations are governed by run profiles (defined in brain files):

- **docs-schema**: Docs/validation only, no live store required
- **read-live**: Read-only queries, requires live store
- **mutation-approved**: Write operations, requires explicit approval
- **theme-dev**: Theme development (preview), allows mutation
- **theme-publish**: Live theme publish, blocked by default
- **integration-governance**: System mapping, no mutation

### Testing

```bash
# Test Shopify CLI
shopify version

# Test MCP
openclaw agent bsi-shopify-mcp
# Ask: "List products from my Shopify store"
```

## Troubleshooting

### CLI not found

- Install: `npm install -g @shopify/cli`
- Check PATH: `which shopify`

### Access token invalid

- Verify token in Shopify Admin → Apps → Develop apps
- Ensure Admin API scopes are configured
- Reinstall the app if needed

### Store domain wrong

- Use full domain: `your-store.myshopify.com`
- Not the custom domain (e.g., `yourstore.com`)

### MCP server errors

- Restart OpenClaw gateway: `openclaw gateway restart`
- Check `npx shopify-mcp` runs without errors
- Verify token and domain in openclaw.json

### Theme operations fail

- Ensure you're authenticated: `shopify auth login`
- Check theme ID is correct: `shopify theme list`
- Theme publish requires explicit approval (run profile)

## Updates

```bash
# Update Shopify CLI
npm update -g @shopify/cli

# Dev MCP updates automatically via npx
```

Then restart OpenClaw gateway.
