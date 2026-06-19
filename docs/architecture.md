# Architecture — delements-web-stack

## Overview

This stack integrates three platforms into a unified AI-powered web development workflow:

```
┌─────────────────────────────────────────────────────────────┐
│                     OpenClaw Gateway                         │
│                  (AI Agent Orchestration)                    │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│  Figma MCP    │  │ Webflow MCP   │  │ Shopify MCP   │
│  + Plugin     │  │ Server        │  │ + Dev MCP     │
└───────┬───────┘  └───────┬───────┘  └───────┬───────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│ Figma Desktop │  │  Webflow      │  │  Shopify      │
│  (Design)     │  │  (CMS/Site)   │  │  (Commerce)   │
└───────────────┘  └───────────────┘  └───────────────┘
```

## Components

### 1. Figma Integration

**Purpose**: Design file management, component libraries, design tokens

**Architecture**:
- **MCP Server**: Node.js server running via `npx tsx`
- **Figma Plugin**: React plugin running inside Figma Desktop
- **Communication**: WebSocket between MCP server and plugin
- **Transport**: stdio (OpenClaw ↔ MCP server)

**Data Flow**:
```
OpenClaw Agent
    ↓ (stdio)
Figma MCP Server (Node.js)
    ↓ (WebSocket)
Figma Plugin (React)
    ↓ (Figma Plugin API)
Figma Desktop
```

**Key Files**:
- `~/Documents/HH/figma-mcp-server/mcp/` — MCP server code
- `~/Documents/HH/figma-mcp-server/plugin/` — Figma plugin code
- `~/.openclaw/openclaw.json` → `mcp.servers.figma`

**Constraints**:
- Plugin must be open in Figma Desktop
- User must be logged into Figma
- File access requires proper permissions

### 2. Webflow Integration

**Purpose**: Site management, CMS operations, design token management

**Architecture**:
- **MCP Server**: `webflow-mcp-server` (npx package)
- **Auth**: OAuth via mcporter OR token-based
- **Transport**: stdio (OpenClaw ↔ MCP server)

**Data Flow**:
```
OpenClaw Agent
    ↓ (stdio)
Webflow MCP Server (npx)
    ↓ (HTTP/GraphQL)
Webflow API
    ↓
Webflow Sites/CMS
```

**Key Files**:
- `~/.openclaw/openclaw.json` → `mcp.servers.webflow`
- `~/.openclaw/workspace/config/mcporter.json` — OAuth config

**Auth Methods**:
1. **Token**: Set `WEBFLOW_TOKEN` in env/.env
2. **OAuth**: Use mcporter with `baseUrl: https://mcp.webflow.com/mcp`

### 3. Shopify Integration

**Purpose**: Store management, product operations, theme development

**Architecture**:
- **Shopify MCP**: `shopify-mcp` — Admin API access
- **Shopify Dev MCP**: `@shopify/dev-mcp` — docs, schema, validation
- **Shopify CLI**: `@shopify/cli` — live store auth, theme dev
- **Transport**: stdio (OpenClaw ↔ MCP servers)

**Data Flow**:
```
OpenClaw Agent
    ↓ (stdio)
Shopify MCP Server (npx)
    ↓ (Admin API GraphQL)
Shopify Store
```

**Key Files**:
- `~/.openclaw/openclaw.json` → `mcp.servers.shopify` + `shopify-dev-mcp`
- `~/.openclaw/openclaw.json` → `mcp.servers.shopify-dev-mcp`

**Run Profiles** (risk-based access control):
- `docs-schema` — No live store, docs only
- `read-live` — Read-only queries
- `mutation-approved` — Write operations (requires approval)
- `theme-dev` — Theme development (preview)
- `theme-publish` — Live publish (blocked by default)

## BSI Agent Topology

```
┌─────────────────────────────────────────────────────────────┐
│                    IT Helpdesk (Intake)                      │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│ BSI Figma     │  │ BSI Webflow   │  │ BSI Shopify   │
│ Executor      │  │ Executor      │  │ Executor      │
└───────┬───────┘  └───────┬───────┘  └───────┬───────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│ BSI Figma     │  │ BSI Webflow   │  │ BSI Shopify   │
│ MCP           │  │ MCP           │  │ MCP           │
└───────────────┘  └───────────────┘  └───────────────┘
```

**Roles**:
- **MCP Agents**: Server config, protocol handling, tool registration
- **Executor Agents**: Operations execution, business logic, artifact creation
- **IT Helpdesk**: Intake, triage, routing to appropriate BSI agent

## Data Governance

### Secrets Management
- All tokens stored in `env/.env` (never committed)
- Scripts read from `.env` and inject into configs
- OAuth tokens managed separately via mcporter

### Brain Files
- Shared governance rules in `brains/` directory
- Each platform has its own brain (BRAIN.md + RULES.md)
- Agents must read brain before executing operations
- Execution agents are read-only on brain files

### Handoff Rules
- Defined in `templates/handoff_rules.yaml`
- Enforce required fields for agent-to-agent communication
- Prevent unauthorized cross-agent operations

## Deployment Modes

### Single Mac (Current)
- All components run on one machine
- Figma Desktop + Plugin local
- OpenClaw gateway local

### Multi-Mac (Future)
- OpenClaw gateway on central server
- Figma Desktop + Plugin on design workstation
- Shopify CLI on commerce workstation
- Agents coordinate via OpenClaw sessions

## Security Considerations

1. **Token Exposure**: Never commit `.env` or tokens to git
2. **Figma Plugin**: Requires manual import per machine
3. **Shopify Mutations**: Blocked by default, require explicit approval
4. **Webflow OAuth**: Tokens scoped to specific sites
5. **Agent Isolation**: Each agent has its own workspace directory

## Troubleshooting

See `docs/troubleshooting.md` for common issues.
