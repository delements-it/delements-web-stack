# TOOLS.md - BSI | Figma MCP Local Notes

## Figma MCP Server

**Config**: `openclaw.json` → `mcp.servers.figma`
**Transport**: `stdio` (npx tsx src/index.ts)

### Architecture
- MCP server ↔ WebSocket ↔ Figma Plugin (must be running in Figma Desktop)
- Plugin sends tasks to Figma, returns results via WebSocket
- **Plugin MUST be open** in Figma Desktop for tools to work

### Available Tools (23 total)
- **Create**: createRectangle, cloneNode, createFrame, createText, createInstance, addComponentProperty, createComponent, createImage, addPrototypeLink
- **Read**: getSelection, getNodeInfo, getAllComponents, getPages
- **Update**: moveNode, resizeNode, setFillColor, setStrokeColor, setCornerRadius, setLayout, editComponentProperty, setInstanceProperties, setParentId, setNodeComponentPropertyReferences
- **Delete**: deleteNode, deleteComponentProperty

### Known Issues
- Plugin must be running in Figma Desktop for any write/read operation
- `_whoami` can be used to verify MCP server connectivity
