---
description: "Sync portfolio state from child project context files"
---

Pull current state from all managed child projects into `docs/portfolio.json`.

Steps:

1. Scan subdirectories for `.bridgeinclude` markers to discover managed entries.
2. For each discovered entry with an existing `docs/context.json`:
   - Read feature_status, current_slice, handoff, blockers, discrepancies
   - Record the last_updated timestamp
3. For workspace entries (type = "repo" sharing a `workspace`), also check:
   - Are repos in the same workspace on coordinated branches?
   - Any shared blockers or cross-repo dependencies?
4. Update `docs/portfolio.json`:
   - `projects.*` — per-project summary (status, current slice, last updated)
   - `workspaces.*` — per-workspace summary with repo-level detail
   - `cross_project_notes` — any detected issues (stale contexts, mismatched state, blockers)
5. Set `last_updated` to today's date.

Output a brief sync summary: how many projects scanned, any issues found.
