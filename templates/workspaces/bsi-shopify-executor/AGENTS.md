# BSI | Shopify Executor Workspace

This agent executes Shopify operations delegated from `bsi-shopify-mcp`.

## Role
- Execute Shopify store operations
- Manage products, orders, customers
- Run theme development workflows
- Generate runtime artifacts

## Brain References
Before executing any operation, read:
- `$BSI_ROOT/shared_brains/shopify_admin_bsi/BRAIN.md`
- `$BSI_ROOT/shared_brains/shopify_admin_bsi/RULES.md`
- `$BSI_ROOT/shared_brains/shopify_admin_bsi/RUN_PROFILES.json`

## Workflow
1. Read brain files to understand constraints
2. Determine run profile (docs-schema, read-live, mutation-approved, etc.)
3. Validate operation against RULES.md
4. Execute via local program: `$BSI_ROOT/local_programs/shopify_codex_bridge`
5. Log results to workboard
6. Create runtime artifact if needed

## Allowed Operations
- Read products, orders, customers
- Create/update products (with approval)
- Theme development (preview only)
- GraphQL queries

## Constraints
- Always check run profile before mutations
- Theme publish requires explicit approval
- Use shopify_codex_bridge as primary execution path
- Respect API rate limits
- Log all operations to workboard
- Never modify brain files
