# Skills

Skills tự động hóa cho Figma, Webflow, Shopify web stack.

## Cấu trúc

```
skills/
├── openclaw/                    # OpenClaw plugin skills
│   └── browser-automation/      # Web testing, login, tab management
└── codex/                       # Codex CLI skills
    ├── figma-mcp-ui-translator/ # Design brief → Figma MCP commands
    ├── figma-webar-converter/   # Figma prototype → WebAR
    ├── webflow-codex/           # Webflow MCP + CMS + Designer
    ├── design-md-webflow-adapter/ # DESIGN.md → Webflow briefs
    └── website-builder-skill/   # Build/audit websites
```

## Cài đặt

```bash
make skills
# hoặc
bash scripts/10-install-skills.sh
```

Script sẽ:
- Copy OpenClaw skills vào `~/.openclaw/plugin-skills/`
- Copy Codex skills vào `~/.codex/skills/`

## Chi tiết từng skill

### OpenClaw: browser-automation

Điều khiển trình duyệt qua OpenClaw browser tool:
- Multi-step web flows (login, form submission)
- Tab management, stale ref recovery
- Screenshot, snapshot, element interaction
- Playwright-backed automation

### Codex: figma-mcp-ui-translator

Chuyển đổi human design brief thành Figma MCP commands:
- Scene breakdown, frame hierarchy
- Token decisions (colors, spacing, typography)
- MCP-safe creation order
- Follow-up polish passes

### Codex: figma-webar-converter

Chuyển Figma prototype thành WebAR website:
- WebXR camera AR experiences
- Three.js desktop preview
- 2D clickable prototype
- Wire/layer audit (JSON + Markdown)

### Codex: webflow-codex

Webflow integration đầy đủ:
- Webflow MCP endpoint (`https://mcp.webflow.com/mcp`)
- CMS operations (collections, items, fields)
- Designer tools, custom code, Code Components
- Spline 3D integrations
- Local QA loops

### Codex: design-md-webflow-adapter

Chuyển DESIGN.md profiles thành Webflow design briefs:
- VoltAgent/awesome-design-md integration
- Brand/style token normalization
- Inspiration profiles: Nike, PlayStation, SpaceX, Framer, Webflow
- UI/UX guardrails linting

### Codex: website-builder-skill

Build và audit Webflow/static websites:
- SEO optimization (Google AI search readiness)
- Accessibility (WCAG, axe-core)
- Performance (Lighthouse, Web Vitals)
- Responsive/mobile design
- Escalation routing (local → OpenClaw → Codex)
