# delements-web-stack

Bộ cấu hình hoàn chỉnh để triển khai **Figma → Webflow → Shopify** web stack trên macOS, tích hợp sẵn với [OpenClaw](https://github.com/openclaw/openclaw) AI agent framework.

## 🏗️ Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Figma      │     │  Webflow     │     │  Shopify     │
│  (Design)    │     │  (CMS/Site)  │     │  (Commerce)  │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                     │
  Figma MCP          Webflow MCP           Shopify MCP
  Server +           Server                Server + Dev MCP
  Plugin                                 + Shopify CLI
       │                    │                     │
       └────────────────────┼─────────────────────┘
                            │
                    OpenClaw Gateway
                    (AI Agent Hub)
                            │
              ┌─────────────┼─────────────┐
              │             │             │
        BSI Figma     BSI Webflow   BSI Shopify
        Agents        Agents        Agents
```

## 📋 Yêu cầu hệ thống

- macOS (Apple Silicon recommended)
- [Homebrew](https://brew.sh)
- Node.js ≥ 20 (khuyến nghị v26+)
- npm ≥ 10
- [OpenClaw](https://docs.openclaw.ai) đã cài đặt

## 🚀 Quick Start

```bash
# 1. Clone repo
git clone https://github.com/delements/delements-web-stack.git
cd delements-web-stack

# 2. Tạo file secrets
cp env/.env.example env/.env
# Chỉnh sửa env/.env với tokens thực của bạn

# 3. Chạy setup toàn bộ
make all

# 4. Kiểm tra
make verify

# 5. Khởi động OpenClaw
openclaw gateway start
```

## 🔧 Setup từng phần

```bash
make figma           # Chỉ setup Figma MCP
make webflow         # Chỉ setup Webflow MCP
make shopify         # Chỉ setup Shopify MCP + CLI
make agents          # Chỉ setup BSI agents
make local-programs  # Copy local programs to $BSI_ROOT
make auth            # Setup OpenClaw auth profiles
make plugins         # Setup OpenClaw plugins
```

## 📁 Cấu trúc repo

```
delements-web-stack/
├── Makefile                    # Build commands
├── scripts/                    # Install scripts (idempotent)
│   ├── 00-preflight.sh        # Kiểm tra dependencies
│   ├── 01-install-openclaw.sh # Cài OpenClaw
│   ├── 02-setup-figma.sh      # Figma MCP server + plugin
│   ├── 03-setup-webflow.sh    # Webflow MCP config
│   ├── 04-setup-shopify.sh    # Shopify CLI + MCP
│   ├── 05-configure-agents.sh # BSI agent definitions
│   └── 06-verify.sh           # Verify toàn bộ
├── templates/                  # Config templates
│   ├── openclaw.json.tmpl     # OpenClaw MCP config (web section)
│   ├── mcporter.json.tmpl     # mcporter Webflow OAuth
│   ├── handoff_rules.yaml     # Agent handoff rules
│   ├── agent_registry.md      # Agent registry
│   ├── agents/                # Agent definitions
│   └── workspaces/            # Workspace templates
├── brains/                    # Shared brains (non-sensitive)
│   ├── figma_admin_bsi/
│   ├── webflow_admin_bsi/
│   ├── shopify_admin_bsi/
│   ├── shopify_admin_bsi_source/
│   └── obsidian_vault/
├── local_programs/            # Local programs (copied to $BSI_ROOT)
│   ├── shopify_codex_bridge/
│   ├── shopify_brain_builder/
│   └── webflow_codex_bridge/
├── figma-mcp-server/          # Figma MCP patches/docs
├── env/                       # Environment config
│   ├── .env.example           # Secrets template
│   └── .env.schema            # Validation
└── docs/                      # Documentation
    ├── architecture.md
    ├── figma-setup.md
    ├── webflow-setup.md
    ├── shopify-setup.md
    └── troubleshooting.md
```

## 🔐 Secrets

Repo này **KHÔNG** chứa tokens hay credentials. Tất cả secrets được quản lý qua file `env/.env`:

| Variable | Mô tả | Lấy từ đâu |
|---|---|---|
| `FIGMA_USER_ID` | Figma user ID | Figma Desktop → Profile |
| `FIGMA_MCP_DIR` | Local clone path for `figma-mcp-server` | Default: `$HOME/Documents/WORKSPACES/AI Coding Tools/figma-mcp-server` |
| `WEBFLOW_TOKEN` | Webflow API token | Webflow → Settings → API |
| `SHOPIFY_ACCESS_TOKEN` | Shopify Admin API token | Shopify Admin → Apps → Develop apps |
| `SHOPIFY_DOMAIN` | Store domain | `your-store.myshopify.com` |
| `OPENCLAW_GATEWAY_TOKEN` | OpenClaw gateway auth token | Auto-generated |
| `BSI_ROOT` | Business Systems Integration project root | `$HOME/Documents/Business Systems Integration` |

## 🎨 Figma Integration

- **MCP Server**: [figma-mcp-server](https://github.com/Antonytm/figma-mcp-server) — stdio transport
- **Plugin**: React plugin chạy trong Figma Desktop, giao tiếp qua WebSocket
- **Tools**: 23 tools (create, read, update, delete nodes/components)
- **Yêu cầu**: Plugin phải được mở trong Figma Desktop khi dùng

## 🌐 Webflow Integration

- **MCP Server**: `webflow-mcp-server` (npx)
- **Auth**: OAuth qua mcporter hoặc token-based
- **Tools**: Sites, pages, CMS collections, components, styles, elements
- **Designer tools**: Element builder, style tool, variable tool, component tool

## 🛒 Shopify Integration

- **MCP Server**: `shopify-mcp` (npx) — Admin API access
- **Dev MCP**: `@shopify/dev-mcp` — docs, schema, validation, code generation
- **CLI**: `@shopify/cli` — live store auth, theme dev, Admin GraphQL
- **Store**: Configured per-store với run profiles (read-only, mutation, theme)

## 🤖 BSI Agents

6 agents trong bộ Business Systems Integration:

| Agent | Role |
|---|---|
| `bsi-figma-mcp` | Figma MCP server config & protocol |
| `bsi-figma-executor` | Figma operations executor |
| `bsi-webflow-mcp` | Webflow MCP server config & protocol |
| `bsi-webflow-executor` | Webflow operations executor |
| `bsi-shopify-mcp` | Shopify MCP server config & protocol |
| `bsi-shopify-executor` | Shopify operations executor |

## 📦 Local Programs

3 local programs được copy vào `$BSI_ROOT/local_programs/`:

| Program | Mô tả |
|---|---|
| `shopify_codex_bridge` | Shopify execution bridge (primary path) |
| `shopify_brain_builder` | Brain maintenance và build tool |
| `webflow_codex_bridge` | Webflow execution bridge |

## 🎯 Skills

**OpenClaw Skills** (1 skill):
- `browser-automation` - Web testing, login flows, tab management

**Codex Skills** (5 skills):
- `figma-mcp-ui-translator` - Convert design briefs to Figma MCP commands
- `figma-webar-converter` - Convert Figma prototypes to WebAR
- `webflow-codex` - Webflow MCP integration, CMS, Designer tools
- `design-md-webflow-adapter` - DESIGN.md profiles to Webflow briefs
- `website-builder-skill` - Build/audit Webflow & static sites with SEO, a11y, performance

## 📖 Documentation

- [Architecture](docs/architecture.md) — System design & data flow
- [Figma Setup](docs/figma-setup.md) — Detailed Figma guide
- [Webflow Setup](docs/webflow-setup.md) — Detailed Webflow guide
- [Shopify Setup](docs/shopify-setup.md) — Detailed Shopify guide
- [Troubleshooting](docs/troubleshooting.md) — Common issues

## 📄 License

Internal use — Delements © 2026
