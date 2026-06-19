# End-To-End Workflow Audit

Created: 2026-05-23

Scope: audit how the local program should work with Qwen local + OpenClaw + Codex/Webflow MCP for website building.

## Target Operating Model

```text
Input: Figma / HTML / live URL / Webflow site
  ↓
Local program
  - skills:list
  - html:analyze / site:analyze / seo:analyze
  - audit / repair:from-audit
  - webflow:inventory
  - build:brief
  ↓
Task router
  - local-program
  - qwen-local
  - codex-or-human-approval
  ↓
Qwen local + OpenClaw
  - bounded reasoning
  - patch/schema/content plan
  - command JSON
  ↓
Local program
  - validate
  - dry-run
  - execute deterministic Webflow API/custom-code/CMS operations
  - audit again
  ↓
Codex/Webflow MCP only if needed
  - native Designer canvas
  - complex Webflow IX2/component work
  - escalation after failed Qwen loops
  - high-risk production approval
```

## Current Strengths

- Local program already has deterministic Webflow API actions.
- `skills:list` can load `SKILL.md` plus references/rules attachments.
- `build:brief` creates a bounded packet for Qwen/Codex.
- `task:route` already separates local/Qwen/Codex ownership.
- Existing skills cover Webflow, Qwen, Spline, UI/UX, responsive, SEO, and escalation.

## Potential Issues

| ID | Issue | Risk | Owner | Fix priority |
| --- | --- | --- | --- | --- |
| P-01 | Qwen/OpenClaw may output invalid commands or broad tool actions | unwanted mutation or wasted loop | local program | P0 |
| P-02 | No strict JSON schema for Qwen/Codex command plans | parser ambiguity | local program | P0 |
| P-03 | Handoff packets may include stale audit/analysis artifacts | wrong decisions | local program | P0 |
| P-04 | Secrets may leak into handoff if future file packing is careless | credential exposure | local program | P0 |
| P-05 | Webflow API cannot safely do every native Designer change | false automation confidence | Codex/MCP | P0 |
| P-06 | Static HTML analysis cannot catch all runtime mobile bugs | missed responsive issues | local program | P1 |
| P-07 | Qwen local may drift after long tool loops | low-quality patches | Qwen/OpenClaw | P1 |
| P-08 | No explicit WIP limits or loop budget | slow work, repeated fixes | process | P1 |
| P-09 | Spline embeds can harm mobile/GPU performance | poor UX | local/Qwen | P1 |
| P-10 | SEO/AI-search work can become fake optimization | ranking/quality risk | local/Qwen | P1 |
| P-11 | No rollback plan for custom code/CMS mutation | hard recovery | local program | P1 |
| P-12 | Codex escalation criteria not attached to Kanban board | unclear handoff | process | P2 |

## Lean Diagnosis

Waste to remove:

- Waiting: avoid asking Codex/Qwen before local analysis exists.
- Overprocessing: do not pack whole repo/site when `build:brief` is enough.
- Defects: validate command JSON before execution.
- Motion: keep commands standardized.
- Inventory: keep only latest relevant artifacts in handoff.
- Overproduction: avoid generating long strategy docs unless needed for the current ticket.

## Kanban Policy

Columns:

```text
Backlog → Ready → In Progress → Review/Validate → Blocked/Escalate → Done
```

WIP limits:

- In Progress: 1 active website/page repair at a time.
- Qwen loop: max 2 repair attempts before Codex escalation.
- Codex/MCP: only one high-risk production change at a time.

Definition of Ready:

- target URL/site/page known
- latest analysis/audit exists or command to generate it is listed
- owner is set by `task:route`
- allowed actions and forbidden actions are clear

Definition of Done:

- local verification command passed
- dry-run was used before Webflow mutation
- audit rerun after change
- publish approval recorded when applicable
- handoff artifacts updated

## Recommended Next Fixes

P0:

1. Add command plan JSON schema.
2. Add command allowlist validator.
3. Add artifact freshness checks.
4. Add secret redaction for handoff packets.

P1:

1. Add Playwright responsive matrix.
2. Add axe-core accessibility audit.
3. Add Lighthouse integration.
4. Add rollback manifest for custom-code/CMS changes.

P2:

1. Add Kanban board generator.
2. Add OpenClaw config templates.
3. Add Spline performance budget checks.
