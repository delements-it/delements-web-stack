---
name: webflow-codex
description: Use when planning, implementing, auditing, or automating Webflow sites through Webflow MCP, Webflow API, CMS/custom code, Code Components, DevLink, Spline integrations, or local QA loops.
---

# Webflow Codex Skill

## Default Stack

- Webflow MCP endpoint: `https://mcp.webflow.com/mcp`
- Webflow Data API for deterministic CMS/custom-code/publish actions.
- Webflow Designer tools or Designer Extension for native canvas edits.
- Local package `webflow-hybrid-automation` for token-free repeatable workflows.
- Spline path: native Webflow Spline, `<spline-viewer>`, `@splinetool/runtime`, or Code Components.

## Workflow

1. Identify site, page, collection, and publish target.
2. Read local context and inventory Webflow state.
3. Prefer draft/staging and reversible custom-code changes.
4. Validate CMS schemas and required fields.
5. Use local audit before and after publish.
6. Use Codex/Webflow MCP only for high-judgment Designer work.

## Skill Coverage

- CMS: collection setup, bulk update, CMS best practices.
- Designer/layout: designer tools, naming, component audit.
- Custom code: register/apply/review/remove scripts.
- Code Components: scaffold, pre-deploy, deploy, troubleshoot.
- Audits: accessibility, assets, links, site health.
- Publishing: safe publish and rollback notes.

## Spline Guardrails

- Do not assume an official public Spline AI generation API.
- Store scene URLs in CMS or a scene registry.
- Always define stable dimensions and mobile fallbacks.
- Lazy-load below-the-fold 3D scenes.

