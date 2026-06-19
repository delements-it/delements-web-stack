# Troubleshooting

## General Issues

### OpenClaw gateway won't start

```bash
# Check status
openclaw gateway status

# View logs
openclaw gateway logs

# Restart
openclaw gateway restart
```

### MCP tools not appearing in agent

1. Verify MCP config in `~/.openclaw/openclaw.json`
2. Check command/args are correct
3. Ensure dependencies are installed (npm install)
4. Restart gateway: `openclaw gateway restart`
5. Test MCP server manually: run the command directly

### Agent workspace not found

```bash
# List workspaces
ls -la ~/.openclaw/workspace-*

# Check agent config
cat ~/.openclaw/openclaw.json | grep -A5 "workspace"
```

## Figma Issues

### Plugin not connecting

**Symptoms**: MCP tools timeout, "Plugin not connected" error

**Solutions**:
1. Ensure Figma Desktop is running (not web)
2. Open the plugin: Plugins → Development → Figma MCP Server
3. Check plugin shows "Connected" status
4. Verify WebSocket port 38450 is not blocked: `lsof -i :38450`
5. Rebuild plugin: `cd "$FIGMA_MCP_DIR/plugin" && npm run build`

### MCP server crashes

**Symptoms**: Agent returns error, MCP server process dies

**Solutions**:
1. Check logs: `openclaw agent bsi-figma-mcp` → ask for error details
2. Verify Node.js version: `node -v` (need ≥ 20)
3. Reinstall dependencies: `cd "$FIGMA_MCP_DIR/mcp" && npm install`
4. Check for syntax errors in MCP config

### Tools return empty/wrong data

**Symptoms**: `getNodeInfo` returns null, `getSelection` empty

**Solutions**:
1. Ensure correct file is open in Figma Desktop
2. Verify file_key matches the open file
3. Check plugin has permissions (manifest.json → permissions)
4. Try `_whoami` to test basic connectivity

## Webflow Issues

### Token authentication fails

**Symptoms**: "Unauthorized" or "Invalid token" errors

**Solutions**:
1. Verify token in Webflow Dashboard → Settings → API
2. Check token hasn't expired
3. Ensure token has correct scopes
4. Update token in `env/.env` and re-run `make webflow`

### OAuth flow hangs

**Symptoms**: Browser opens but doesn't redirect back

**Solutions**:
1. Check default browser is set correctly
2. Try manual OAuth: `mcporter auth webflow`
3. Verify mcporter config: `cat ~/.openclaw/workspace/config/mcporter.json`
4. Switch to token-based auth instead

### Site not accessible

**Symptoms**: "Site not found" or "Access denied"

**Solutions**:
1. Verify site_id is correct: `webflow__sites_list`
2. Check token has access to that site
3. Ensure site is published (for some operations)
4. Verify Webflow plan includes API access

## Shopify Issues

### CLI authentication fails

**Symptoms**: `shopify auth login` fails or hangs

**Solutions**:
1. Clear auth cache: `shopify auth logout`
2. Check store domain is correct
3. Verify you have admin access to the store
4. Try browser-based auth: `shopify auth login --store your-store.myshopify.com`

### Access token invalid

**Symptoms**: "Invalid API key or access token" errors

**Solutions**:
1. Verify token in Shopify Admin → Apps → Develop apps
2. Check Admin API scopes are configured
3. Ensure app is installed (not just created)
4. Regenerate token if needed

### GraphQL validation errors

**Symptoms**: "Field doesn't exist" or "Invalid query" errors

**Solutions**:
1. Use `shopify-dev-mcp__learn_shopify_api` to check API version
2. Validate query: `shopify-dev-mcp__validate_graphql_codeblocks`
3. Check API version in query matches store version
4. Verify field names are correct (camelCase vs snake_case)

### Theme operations blocked

**Symptoms**: "Theme publish blocked by run profile"

**Solutions**:
1. This is intentional — theme publish requires explicit approval
2. Use `theme-dev` profile for preview/development
3. Request approval for `theme-publish` profile
4. Check brain files for run profile rules

## Agent Issues

### Agent not responding

**Symptoms**: Agent session hangs or times out

**Solutions**:
```bash
# List active sessions
openclaw sessions list

# Kill stuck session
openclaw sessions kill <session-id>

# Restart gateway
openclaw gateway restart
```

### Handoff fails

**Symptoms**: "Invalid handoff" or "Required fields missing"

**Solutions**:
1. Check `handoff_rules.yaml` for required fields
2. Verify both agents exist in `openclaw.json`
3. Ensure agent workspaces exist
4. Check brain files for handoff rules

### Brain preflight fails

**Symptoms**: Agent refuses to act, says "brain file missing"

**Solutions**:
1. Verify brain files exist in `brains/` directory
2. Check agent AGENTS.md points to correct brain path
3. Ensure brain files are readable (permissions)
4. Copy brains from repo if missing: `cp -r brains/ ~/.openclaw/workspace-bsi-*/`

## Network Issues

### MCP server can't connect

**Symptoms**: Timeout, connection refused

**Solutions**:
1. Check internet connection
2. Verify firewall isn't blocking localhost connections
3. Test MCP server manually: run command from openclaw.json
4. Check for proxy settings that might interfere

### OAuth redirect fails

**Symptoms**: Browser opens but doesn't complete flow

**Solutions**:
1. Check default browser settings
2. Try different browser
3. Verify OAuth callback URL is accessible
4. Check for ad blockers or privacy extensions

## Performance Issues

### MCP operations slow

**Symptoms**: Tools take > 10 seconds to respond

**Solutions**:
1. Check network latency to external APIs
2. Verify MCP server isn't CPU-bound: `top` or Activity Monitor
3. Reduce payload size (fewer items per request)
4. Consider caching for read-heavy operations

### Figma plugin laggy

**Symptoms**: Plugin UI slow, operations delayed

**Solutions**:
1. Close unused Figma files
2. Reduce number of selected nodes
3. Restart Figma Desktop
4. Rebuild plugin with optimizations

## Getting Help

If issues persist:

1. Check OpenClaw docs: https://docs.openclaw.ai
2. Review agent logs: `openclaw gateway logs`
3. Test MCP servers independently
4. Verify all dependencies are up to date
5. Check GitHub issues for specific MCP servers

## Reset Everything

Nuclear option — remove all configs and start fresh:

```bash
# Backup current config
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# Remove MCP entries (manually edit openclaw.json)
# Remove workspace directories
rm -rf ~/.openclaw/workspace-bsi-*

# Remove Figma MCP server
rm -rf "$FIGMA_MCP_DIR"

# Re-run setup
cd delements-web-stack
make all
```
