# webflow_admin_bsi Rules

## Mandatory Preflight
Before any non-trivial action:
1. Read this brain and rules files
2. Read the worker envelope or task context
3. Confirm artifact destination: `$BSI_ROOT/runtime/`
4. Confirm allowed paths and side-effect policy
5. Check `~/.openclaw/workspace/handoff_rules.yaml` for valid handoff contracts

## Stop Conditions
Stop and report when:
- A required brain file is missing
- Routing is unclear
- The handoff rule for the requested action is missing
- The task is outside Business Systems Integration scope
- Required fields are missing from handoff envelope

## Completion Conditions
Do not mark work complete unless:
- Session transcript exists
- At least one runtime artifact exists
- Artifact path is recorded
- Next action or handoff target is clear

## Allowed Commands
- submit-artifact
- request-agent-work
- create-workboard-card
- update-workboard-status
- write-runtime-artifact
- reference-local-program

## Forbidden Commands
- direct-db-edit
- final-approval-without-policy
- credential-dump
- unbounded-routing-change
- editing other agents' workspaces
