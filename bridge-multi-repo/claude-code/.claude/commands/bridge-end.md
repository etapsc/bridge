---
description: "End workspace session — save cross-repo state and handoff notes"
---

## TASK — WORKSPACE SESSION WRAP-UP

### Step 1: Capture Repo State

For each repo in `workspace.repos`:
1. Check current branch, clean/dirty status, HEAD SHA
2. Check for open PRs related to current slice
3. Update `repo_state` in docs/context.json

### Step 2: Update Context

Update docs/context.json:
- `handoff.stopped_at` — what was the last thing completed
- `handoff.next_immediate` — what should happen next session
- `handoff.watch_out` — any gotchas or risks
- `current_slice` — current state of active slice
- `feature_status` — update any status changes
- `last_updated` — today's date

### Step 3: Log Decisions

Append any architectural decisions made this session to docs/decisions.md:
```
YYYY-MM-DD: [decision] — [rationale] (Slice: S{xx})
```

### Step 4: Output Summary

```
### Session Summary

#### Work Completed
- [what was done, per repo]

#### Repo State at End
| Repo | Branch | Clean | HEAD SHA |
|------|--------|-------|----------|

#### Handoff
- Next: [what to do next]
- Watch out: [risks/gotchas]

#### Files Modified
- docs/context.json — updated
- docs/decisions.md — [N] decisions logged
```
