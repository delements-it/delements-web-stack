# Lean + Kanban Operating Model

Created: 2026-05-23

## Lean Principles

1. Define value

Value is a working, mobile-friendly, indexable, auditable Webflow website with minimal token spend and reversible changes.

2. Map the value stream

```text
Input → Local analysis → Route → Qwen/Codex only if needed → Local execution → Audit → Publish approval
```

3. Create flow

Use small repair batches. One page or one component family per ticket.

4. Establish pull

Do not send work to Qwen or Codex until the local program has produced a brief or a blocker.

5. Pursue quality at the source

Every generated command or patch must be validated locally before Webflow mutation.

## Kanban Board

| Column | Entry policy | Exit policy |
| --- | --- | --- |
| Backlog | idea/problem exists | scope and target clarified |
| Ready | target, owner, artifacts, allowed actions known | worker starts |
| In Progress | WIP slot available | patch/plan produced |
| Review/Validate | command/patch ready | local checks pass |
| Blocked/Escalate | local/Qwen cannot safely proceed | Codex/MCP/human accepts |
| Done | verification passed | outcome documented |

## WIP Limits

- Backlog: unlimited, but should be pruned weekly.
- Ready: max 5 tickets.
- In Progress: max 2 tickets total.
- Qwen local: max 1 active repair loop.
- Codex/MCP: max 1 active escalation.
- Review/Validate: max 3 tickets.

## Policies

- No publish from Qwen output.
- No Webflow mutation without dry-run if the command supports it.
- No broad redesign without a build brief.
- No third Qwen repair attempt without Codex escalation.
- No production-domain/payment/credential changes without human approval.
- No hidden SEO/AI-search hacks.

## Metrics

Track:

- cycle time per ticket
- number of Qwen loops before pass
- number of Codex escalations
- audit score before/after
- Webflow mutation count
- rollback count
- escaped defects after publish

## Stop-The-Line Conditions

Stop and escalate if:

- Webflow API returns unexpected shape
- custom code diff is broad or unreviewed
- audit score gets worse after patch
- Qwen output violates JSON contract
- token/context packet includes secrets
- layout breaks at mobile width
