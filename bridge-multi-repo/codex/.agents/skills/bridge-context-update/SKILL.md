---
name: Bridge Context Update
description: Sync workspace context.json with actual cross-repo git state. Invoke with $bridge-context-update in your prompt.
---

Update workspace `docs/context.json` to match the actual state of all repos.

## Steps

1. Load `docs/requirements.json` for workspace topology (`workspace.repos`).
2. Load `docs/context.json` for current recorded `repo_state`, `feature_status`, and `handoff`.
3. For each repo in `workspace.repos`:
   - Check actual git state via the repo's relative path:
     - Current branch name.
     - Clean or dirty working tree.
     - HEAD SHA.
     - Any open PRs on feature branches.
   - Compare against the recorded `repo_state` entry.
   - If drifted, note the discrepancy.
4. Output drift report:

```
### Context Drift Report

| Repo | Field | Recorded | Actual | Drifted |
|---|---|---|---|---|
| [repo-id] | branch | [old] | [new] | YES/NO |
| [repo-id] | sha | [old] | [new] | YES/NO |
| [repo-id] | clean | [old] | [new] | YES/NO |
```

5. Update `docs/context.json`:
   - `repo_state` — update branch, SHA, clean status for all drifted repos.
   - `feature_status` — update if feature state has changed (e.g., PR merged means `done`).
   - `handoff` — update with current session notes if applicable.
   - `slice_history` — append any completed slice evidence.
6. If any repo has unexpected state (wrong branch, uncommitted changes, missing), flag it.

```
HUMAN:
1. Review the drift report — any unexpected changes?
2. If a repo is on an unexpected branch, investigate before approving the update
3. Approve the context.json update or specify corrections
```
