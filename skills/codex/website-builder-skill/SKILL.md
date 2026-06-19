---
name: website-builder-skill
description: Use for building, auditing, and improving Webflow or static websites with local-first UI/UX, responsive/mobile, SEO, Google AI-search readiness, accessibility, performance, Webflow CMS/custom-code, Spline embeds, and escalation routing.
---

# Website Builder Skill

## Mission

Make the local website builder program strong enough to handle deterministic website work before involving OpenClaw or Codex.

Default ownership:

- Local program: analyze, audit, validate, screenshot, generate reports, apply dry-run-safe Webflow API actions.
- OpenClaw: handle bounded repair packets, write patches from compact artifacts, propose CMS schemas, and rewrite metadata/content inside a scoped worker envelope.
- Codex/Webflow MCP: native Webflow Designer canvas, complex interactions, uncertain architecture, production-risk actions.

## Research Baseline

Prefer these proven projects as references or integrations:

- Runtime QA: `microsoft/playwright`, `GoogleChrome/lighthouse`, `dequelabs/axe-core`, `GoogleChrome/web-vitals`.
- Performance/assets: `lovell/sharp`, `sitespeedio/sitespeed.io`, `harlan-zw/unlighthouse`, `QwikDev/partytown`.
- UI/UX patterns: `twbs/bootstrap`, `tailwindlabs/tailwindcss`, `shadcn-ui/ui`, `radix-ui/primitives`, `storybookjs/storybook`.
- SEO/schema: `google/schema-dts`, `SchemaStore/schemastore`, `garmeeh/next-seo`, `iamvishnusankar/next-sitemap`.
- Webflow/Spline: `webflow/js-webflow-api`, `webflow/mcp-server`, `webflow/webflow-skills`, `finsweet/attributes`, `splinetool/react-spline`.

Use UI frameworks as knowledge sources unless the target website is already built with that framework. Do not blindly import Bootstrap, Tailwind, MUI, or Ant Design into existing Webflow sites.

## Design.md Inspiration Layer

Use `design-md-webflow-adapter` when the task asks for a Webflow redesign based on known website styles or design references. It converts `VoltAgent/awesome-design-md` profiles into a normalized Webflow brief before OpenClaw or Codex/Webflow MCP work.

For GameHub/Battlefield-like redesigns, default to these profiles:

- `playstation`
- `spacex`
- `nike`
- `framer`
- `webflow`

Run:

```text
design-md:select --intent gamehub
design-md:ingest --intent gamehub
design-md:lint --installed
design-md:brief --intent gamehub --installed
```

Normalize away brand-specific fonts, negative letter spacing, exact brand cloning, and unsafe responsive assumptions before any Webflow edit plan.

## Local Program Functions

The local program should expose or support:

```text
skills:list
design-md:list
design-md:select
design-md:ingest
design-md:lint
design-md:brief
html:analyze
site:analyze
seo:analyze
audit
audit:lighthouse
audit:a11y
audit:responsive
audit:visual
seo:structured-data
seo:indexability
seo:ai-readiness
assets:optimize
ux:mobile
spline:audit
task:route
repair:from-audit
custom-code:apply --dry-run
cms:sync --dry-run
publish
```

## UI/UX And Mobile Rules

Check:

- viewport meta uses `width=device-width, initial-scale=1`
- no horizontal overflow at mobile/tablet/desktop
- tap targets are at least 44px where practical
- sticky nav does not cover content or CTA
- mobile menus close on link click and Escape
- focus states are visible
- modals/dropdowns do not trap scroll incorrectly
- media has stable aspect ratio and max-width
- text does not overflow buttons/cards
- reduced-motion fallback exists when animations/interactions are used

## SEO And Google AI-Search Rules

Follow Google Search Central guidance: AI features in Google Search use the same SEO foundations. Do not invent fake "AI SEO" markup.

Check:

- title and meta description exist and are unique
- canonical is present for indexable pages
- robots/noindex is intentional
- HTML `lang` is present
- one clear H1, clean heading hierarchy
- important content exists as readable text
- internal links make content discoverable
- images have useful alt text or empty decorative alt
- Open Graph/Twitter preview metadata exists
- JSON-LD is valid and matches visible page content
- sitemap/robots are available when project needs them

Optional: `llms.txt` can be generated for non-Google LLM consumers, but it is not a Google Search requirement.

## Webflow Rules

For Webflow:

- Use Webflow Data API/SDK for deterministic CMS, scripts, page metadata, and publish operations.
- Use Webflow MCP/Designer tools for native canvas and Designer-specific edits.
- Prefer draft/staging and dry-run before mutation.
- Do not modify production custom code without recording previous state.
- Keep Webflow class/style architecture consistent with existing site conventions.
- Treat Finsweet Attributes as Webflow-native behavior helpers, not generic JS snippets.

## Spline Rules

For Spline embeds:

- detect `<spline-viewer>`, Spline iframe, `@splinetool/runtime`, and canvas usage
- lazy-load below-the-fold scenes
- provide fallback poster/static image
- set stable `aspect-ratio`, `min-height`, and mobile bounds
- check scene does not block CTA/nav interactions
- audit GPU/performance risk on mobile

## Escalation

Keep local if the task can be handled by static analysis, browser audit, schema validation, deterministic API calls, or generated guardrails.

Escalate to OpenClaw if the task requires judgment but has a bounded packet:

- write JS/CSS patch
- rewrite metadata
- build CMS schema
- prioritize repair plan
- map Figma/HTML manifest to sections

Escalate to Codex/Webflow MCP if:

- native Webflow Designer canvas is required
- Webflow IX2 interactions need structural changes
- OpenClaw repair loops fail twice
- production publish/domain/payment/credential risk is involved
- visual result needs high-confidence multi-step browser/tool reasoning

## Lean/Kanban Process

Use the process files when auditing or running a website build workflow:

- `process/end-to-end-workflow-audit.md`
- `process/lean-kanban-operating-model.md`
- `fix-scope/fix-backlog-kanban.md`
- `fix-scope/scope-of-work.md`
- `rules/asset-seo-md5-webflow.md`

Default flow:

```text
Backlog -> Ready -> In Progress -> Review/Validate -> Blocked/Escalate -> Done
```

WIP limits:

- OpenClaw: max 1 active repair loop.
- OpenClaw attempts: max 2 before Codex escalation.
- Codex/MCP: max 1 high-risk escalation.
- Review/Validate: max 3 tickets.

Definition of Done:

- latest local analysis/audit exists
- dry-run before Webflow mutation
- output validated against command contract
- audit rerun after patch
- publish approval recorded if applicable

## Asset SEO And MD5

Before uploading assets to Webflow:

- rename files with lowercase, hyphenated, descriptive SEO names
- keep filenames under 100 characters including extension
- compute full MD5 for Webflow `fileHash`
- add a short MD5 suffix to the prepared filename for traceability
- generate a manifest with suggested alt text for images
- flag images over 4MB
- prepare videos locally, but route video upload decisions through Webflow feature constraints

## Output Contract For Agents

When this skill is used by OpenClaw/Codex, return JSON first:

```json
{
  "owner": "local-program|openclaw|codex-webflow-mcp",
  "summary": "",
  "findings": [],
  "commands": [],
  "patches": [],
  "requiresApproval": true,
  "verification": []
}
```

Then provide a short human explanation.
