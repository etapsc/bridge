---
name: Bridge Resume
description: Resume workspace session — load cross-repo state and output brief. Invoke with $bridge-resume in your prompt.
---

Fresh session. Load workspace state and produce a re-entry brief.

## Steps

1. Load `docs/requirements.json` — workspace topology, features, contracts.
2. Load `docs/context.json` — `repo_state`, `feature_status`, `handoff`, `next_slice`.
3. Output the re-entry brief:

```
### Workspace Re-entry Brief

#### Workspace Topology
[List repos from workspace.repos with their paths and roles]

#### Repo State
| Repo | Branch | SHA | Status | PR |
|---|---|---|---|---|
[From repo_state — one row per repo with active work]

#### Current Slice: S{xx} — [goal]
- Impacted repos: [list]
- Status: [in-progress / review / blocked]
- Evidence collected: [per-repo summary]

#### Handoff Notes
[From context.json handoff section — what was in progress, what's next]

#### Next Action
[What the previous session recommended doing next]
```

4. Wait for instructions. Do not proceed with implementation until the user directs.

```
HUMAN:
1. Verify the workspace state matches your expectations
2. Check that repo branches/SHAs are current (run $bridge-repo-status if unsure)
3. Tell me what to work on: continue current slice, start new slice, or specific task
```
