# Local Program Skill Map

This maps retained research projects into local program functions.

## Immediate Functions

| Function | Backing project/reference | Purpose |
| --- | --- | --- |
| `html:analyze` | local rules, Google SEO docs | static HTML UI/UX/SEO analysis |
| `site:analyze` | local rules, Chrome CDP | live URL analysis |
| `skills:list` | local skill reader | load `SKILL.md` knowledge |
| `design-md:select` | `VoltAgent/awesome-design-md` profile map | choose design reference profiles by intent |
| `design-md:ingest` | local Design.md adapter | install selected DESIGN.md profiles into local skill references |
| `design-md:lint` | local Webflow guardrails | flag brand fonts, negative letter spacing, generated markers, and missing responsive rules |
| `design-md:brief` | local Design.md adapter | create a compact Webflow-ready design handoff for Qwen/Codex |
| `task:route` | local escalation policy | decide local/Qwen/Codex owner |
| `interactions:plan` | Bootstrap/Tailwind/Radix/Webflow rules | mobile UX and responsive guardrails |
| `plan:validate` | local command schema + allowlist | validate Qwen/OpenClaw/Codex command plans before mutation |
| `plan:run` | local executor + rollback manifest | execute local-first actions and write MCP handoff packets |

## Next Strong Additions

| Function | Tool to integrate | Priority | Why |
| --- | --- | ---: | --- |
| `audit:lighthouse` | `GoogleChrome/lighthouse` | P1 | Standard performance/SEO/accessibility score |
| `audit:responsive` | `microsoft/playwright` | P1 | Real mobile/tablet/desktop viewport checks |
| `audit:a11y` | `dequelabs/axe-core` | P1 | Accessibility engine |
| `assets:optimize` | `sharp` | P1 | Resize and convert assets |
| `assets:prepare` | Node crypto + filename rules | P0 | SEO filename + MD5 manifest before Webflow upload |
| `assets:upload` | Webflow Assets API | P1 | Upload supported prepared assets using `fileName` + `fileHash` |
| `seo:structured-data` | `google/schema-dts`, Schema.org rules | P1 | Validate JSON-LD |
| `seo:indexability` | Google Search docs | P1 | robots/noindex/canonical/sitemap checks |
| `audit:sitewide` | `harlan-zw/unlighthouse` | P2 | Whole-site Lighthouse crawl |
| `perf:third-party` | `Partytown`, Lighthouse | P2 | detect heavy third-party scripts |
| `spline:audit` | Spline docs/runtime patterns | P1 | 3D embed performance and mobile safety |
| `mcp:designer-client` | Webflow MCP client | P1 | Direct Designer tool execution after approval and bridge checks |

## Data Artifacts

Local program should write:

```text
artifacts/analysis/latest.json
artifacts/audit/latest.json
artifacts/lighthouse/latest.json
artifacts/a11y/latest.json
artifacts/responsive/latest.json
artifacts/seo/latest.json
artifacts/design-md/latest-brief.json
artifacts/design-md/latest-brief.md
artifacts/design-md/latest-lint.json
artifacts/assets/latest.json
artifacts/handoff/latest-route.json
artifacts/executor-runs/latest.json
```

## Handoff Packet

When local rules are not enough, hand off only a bounded packet:

```json
{
  "analysis": "artifacts/analysis/latest.json",
  "audit": "artifacts/audit/latest.json",
  "screenshots": [],
  "inventory": "artifacts/webflow/inventory.json",
  "designMdBrief": "artifacts/design-md/latest-brief.json",
  "allowedActions": ["patch-js", "patch-css", "cms-json", "report-only"],
  "forbiddenActions": ["publish", "delete", "credential-output"]
}
```
