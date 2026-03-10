---
description: "Resume workspace session — load cross-repo state and output brief"
---

Fresh session. Load workspace state and produce a re-entry brief.

## TASK — WORKSPACE RE-ENTRY BRIEF

### Step 1: Load State

1. Load `docs/requirements.json` — workspace topology, features, repos
2. Load `docs/context.json` — repo_state, current_slice, handoff, slice_history

### Step 2: Output Brief

```
### Workspace Re-Entry Brief — [Project Name]

#### Workspace Topology
[List repos with paths and roles]

#### Repo State
| Repo | Branch | HEAD SHA | PR | Status |
|------|--------|----------|-----|--------|
[from repo_state]

#### Current Slice
[S{xx} — goal, impacted repos, what's done, what remains]

#### Last Session
- Stopped at: [handoff.stopped_at]
- Next immediate: [handoff.next_immediate]
- Watch out: [handoff.watch_out]

#### Feature Status
[Summary of planned/in-progress/done features]
```

### Step 3: Wait

Do not take action. Wait for instructions.
