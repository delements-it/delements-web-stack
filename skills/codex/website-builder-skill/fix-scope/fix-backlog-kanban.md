# Fix Backlog Kanban

Created: 2026-05-23

## Backlog

| ID | Title | Priority | Owner | Status |
| --- | --- | --- | --- | --- |
| FIX-001 | Command plan JSON schema | P0 | local program | Done |
| FIX-002 | Command allowlist validator | P0 | local program | Done |
| FIX-003 | Artifact freshness and target hash | P0 | local program | Partial |
| FIX-004 | Secret redaction for handoff packets | P0 | local program | Done |
| FIX-005 | Webflow mutation rollback manifest | P1 | local program | Partial |
| FIX-006 | Playwright responsive matrix | P1 | local program | Backlog |
| FIX-007 | axe-core accessibility audit | P1 | local program | Backlog |
| FIX-008 | Lighthouse audit integration | P1 | local program | Backlog |
| FIX-009 | Spline performance budget | P1 | local + Qwen | Backlog |
| FIX-010 | OpenClaw/Qwen execution contract template | P1 | process | Backlog |
| FIX-011 | Kanban board generator | P2 | local program | Backlog |
| FIX-012 | Codex escalation packet template | P2 | Codex/MCP | Backlog |
| FIX-013 | AI-Chrome Webflow open policy and profile mismatch detection | P0 | local program | Done |
| FIX-014 | Webflow reference black-screen/disclaimer fallback | P0 | local program + Codex brain | Done |
| FIX-015 | Webflow custom-code block and profile-login blocker detection | P0 | local program + Webflow MCP | Ready |

## Ready Cards

### FIX-001 Command Plan JSON Schema

Scope:

- Define accepted command plan fields.
- Require `owner`, `actions`, `requiresApproval`, `verification`.
- Reject unknown action types.

Acceptance criteria:

- Qwen/Codex output can be validated before execution.
- Invalid JSON produces a clear error and no Webflow mutation.

### FIX-002 Command Allowlist Validator

Scope:

- Allow only known local commands.
- Require dry-run for CMS/custom-code mutation unless approval is explicit.
- Block `publish`, `delete`, domain, payment, credential actions by default.

Acceptance criteria:

- A command plan cannot execute arbitrary shell.
- Publish requires explicit approval flag.

### FIX-003 Artifact Freshness And Target Hash

Scope:

- Store target URL/site/page and timestamp in brief.
- Mark artifacts stale if target changes or age exceeds policy.
- Warn before using stale analysis/audit.

Acceptance criteria:

- `build:brief` reports artifact freshness.
- Stale packet routes to local analysis first.

### FIX-004 Secret Redaction For Handoff Packets

Scope:

- Redact known env/token/key patterns.
- Never include `.env` in handoff.
- Flag suspicious credential strings in generated briefs.

Acceptance criteria:

- Brief files do not contain Webflow/Figma/Qwen/OpenAI tokens.
- Redaction test passes on sample secret strings.

### FIX-013 AI-Chrome Webflow Open Policy And Profile Mismatch Detection

Problem:

- Webflow showcase/live previews may use `.webflow.io`, which was not included in all local allowlists.
- Multiple AI-Chrome toolkits can run on the same CDP port with different `AI-Chrome` profile paths.
- When the active CDP browser is launched from a different toolkit path, the local program can open/review the wrong session or ignore newly edited allowlist config.

Scope:

- Add `*.webflow.io` and the Battlefield live preview domain to the GameHub config allowlist.
- Make `mcp:doctor` inspect Chrome processes on the target CDP port.
- Report `ai-chrome-path-mismatch` when the running Chrome profile path differs from configured `aiChrome.cwd/AI-Chrome`.
- Report `allowlist-incomplete` when `.webflow.io` is absent.
- Document that reference review should use the user-opened tab or a new tab only, never overwrite a protected current tab.

Acceptance criteria:

- `node run-local.mjs mcp:doctor` surfaces path mismatch before Webflow MCP work.
- Made-in-Webflow project previews on `.webflow.io` are allowed.
- The workflow clearly distinguishes browser observation from Designer mutation.

### FIX-014 Webflow Reference Black-Screen/Disclaimer Fallback

Problem:

- Some Made-in-Webflow live reference projects open to a black disclaimer/loading screen.
- First viewport screenshots may show only black background and tiny disclaimer text, while the useful UI reference is inside the showcase preview, animated thumbnail, clone preview, or after user interaction.
- Treating that first viewport as the design reference causes bad UI analysis and wastes Codex tokens.

Scope:

- Mark black first-viewport reference pages as inconclusive, not as final visual evidence.
- Prefer this order for Webflow references:
  1. User-opened tab screenshot when available.
  2. Made-in-Webflow detail page screenshot.
  3. Live `.webflow.io` page after waiting and checking for visible UI.
  4. Showcase animated thumbnail or preview asset when live page is a disclaimer/black screen.
  5. Local design-md brief if browser reference remains blocked.
- Require Codex brain review before using a black-screen reference to drive Webflow redesign.

Acceptance criteria:

- Reference review records whether the screenshot is `usable`, `disclaimer-only`, `blocked`, or `inconclusive`.
- A black/disclaimer-only screenshot cannot be the only source for a redesign handoff.
- The GameHub/Battlefield workflow keeps original GameHub content and uses Battlefield only as interaction/layout inspiration.

### FIX-015 Webflow Custom-Code Block And Profile-Login Blocker Detection

Problem:

- Webflow can show registered scripts for a site while page/site custom-code application still fails with `Custom code block not found`.
- The local program may incorrectly treat a registered JSON-LD or runtime guard script as applied/live.
- Chrome profile can open the Designer bridge to `Login - Webflow`, which means Data API can work while Designer MCP remains unavailable.

Scope:

- Add a custom-code preflight that distinguishes `registered`, `applied`, `custom-code-block-missing`, and `published-live` states.
- Record Webflow API 404 `Custom code block not found` as a blocker, not as a retryable transient error.
- Add a browser/profile preflight that reports `designer-login-required` when the bridge lands on Webflow login.
- Update command plans so script application is skipped or marked blocked when the custom-code block is unavailable.

Acceptance criteria:

- Local program does not repeatedly attempt failing custom-code application.
- JSON-LD and reduced-motion fixes are not marked complete until applied and later visible in live audit after publish.
- Designer MCP handoff states whether the active browser is authenticated and bridge-visible.
