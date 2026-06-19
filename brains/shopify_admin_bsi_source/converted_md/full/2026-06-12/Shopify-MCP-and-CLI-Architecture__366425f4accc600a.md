# Shopify MCP and CLI Architecture

## Layer 1: Shopify Dev MCP

Dung cho:

- docs lookup
- API understanding
- GraphQL validation
- theme validation
- component validation

Khong dung layer nay de khang dinh da co live store access.

## Layer 2: Shopify CLI

Dung cho:

- `shopify store auth`
- `shopify store execute`
- theme workflows
- app workflows

Day moi la live operation path cho store that.

## Layer 3: Local program

`shopify_codex_bridge` la execution bridge dung chung cho:

- prompt injection
- Business context injection
- profile `IT Helpdesk`
- MCP + CLI routing
