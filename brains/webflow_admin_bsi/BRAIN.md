# Webflow Admin BSI Brain

## Role
This is the brain for Webflow integration operations.

## Scope
- Webflow API operations
- Site management
- CMS item operations
- Design token management

## Brain Files
- BRAIN.md (this file)
- RULES.md
- EXECUTOR_BOOTSTRAP.md
- WEBFLOW_EXECUTOR_CHAT_PROMPT.md

## Handoffs
- → bsi-webflow-mcp: For MCP server operations
- → it-helpdesk: For IT support requests

## Rules
1. Always validate site_id before operations
2. Log all Webflow operations to Workboard
3. Follow API rate limits
4. Block and request info if site configuration missing
