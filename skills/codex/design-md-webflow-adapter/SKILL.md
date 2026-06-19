---
name: design-md-webflow-adapter
description: Use when converting VoltAgent/awesome-design-md DESIGN.md profiles into Webflow-compatible design briefs, selecting inspiration profiles, normalizing brand/style tokens, linting UI/UX guardrails, and preparing Codex/OpenClaw/local executor handoff for Webflow builds.
---

# Design.md Webflow Adapter

## Mission

Use `VoltAgent/awesome-design-md` as a local design intelligence layer for Webflow projects. Treat each `DESIGN.md` as a design reference, not as executable Webflow code and not as permission to clone a brand exactly.

## Default Profile Selection

For GameHub or Battlefield-like redesigns, select:

- `playstation`: gaming product atmosphere and dark campaign hierarchy
- `spacex`: cinematic high-contrast hero sections
- `nike`: bold product storytelling and kinetic section rhythm
- `framer`: polished landing-page structure and animation-friendly layout
- `webflow`: Webflow-native marketing grammar and Designer-friendly constraints

For generic Webflow marketing pages, prefer `webflow`, `framer`, `figma`, `linear.app`, and `vercel`.

## Local Program Commands

Use these before asking Codex or an OpenClaw worker to reason over design direction:

```bash
node run-local.mjs design-md:list
node run-local.mjs design-md:select --intent gamehub
node run-local.mjs design-md:ingest --intent gamehub --source /path/to/awesome-design-md/design-md
node run-local.mjs design-md:lint --installed
node run-local.mjs design-md:brief --intent gamehub --task "redesign GameHub with Battlefield-like UI" --installed
```

The installed selected profiles live under:

```text
skills/website-builder-skill/references/design-md/profiles/
```

Generated briefs live under:

```text
artifacts/design-md/latest-brief.md
artifacts/design-md/latest-brief.json
```

## Normalization Rules

- Preserve the target site's original content unless the user explicitly approves copy changes.
- Use DESIGN.md files as inspiration and constraints, not as exact brand clones.
- Normalize `letter-spacing` to `0` for this local program.
- Replace proprietary or unknown brand fonts with licensed project fonts or system fallbacks.
- Keep Webflow class/style architecture consistent with the target site.
- Validate desktop, tablet, and mobile breakpoints before mutation.
- Keep tap targets near `44px` or larger where practical.
- Avoid one-note palettes; maintain readable contrast and clear CTA hierarchy.
- Use Webflow MCP/Designer handoff for native canvas structure and interactions.
- Use local Data API actions for deterministic CMS, metadata, assets, custom code, and dry-run-safe changes.

## Handoff Contract

When a task uses this skill, first produce or reference a `design-md:brief` artifact. Then route:

- Local program: profile selection, linting, normalized brief, command-plan scaffolding.
- OpenClaw: bounded visual interpretation and JSON command-plan generation from a compact local brief.
- Codex/Webflow MCP: native Designer canvas edits, complex interactions, and high-risk ambiguity.

Never publish, delete, change domains/payment, or expose credentials without explicit approval.
