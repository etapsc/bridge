---
description: "Sync workspace context.json with actual git state across repos"
---

## TASK — WORKSPACE CONTEXT SYNC

### Step 1: Load State

1. Load `docs/requirements.json` — workspace.repos for repo paths
2. Load `docs/context.json` — current repo_state, feature_status, handoff

### Step 2: Check Each Repo

For each repo in workspace.repos:
1. Navigate to repo path (relative)
2. Read current branch, clean/dirty status, HEAD SHA
3. Check for open PRs if possible
4. Compare against recorded `repo_state` in context.json

### Step 3: Detect Drift

```
### Workspace Context Drift Report

| Repo | Field | Recorded | Actual | Drift? |
|------|-------|----------|--------|--------|
[per-repo comparison]
```

### Step 4: Update

Update `docs/context.json`:
- `repo_state` — correct branches, SHAs, PR URLs to match reality
- `feature_status` — update if code inspection reveals status changes
- `handoff` — update if current state differs from recorded handoff
- `last_updated` — today's date

Report what changed and flag anything unexpected (e.g., repo on wrong branch, uncommitted changes, missing feature branches).
