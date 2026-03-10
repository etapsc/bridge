---
description: "Start workspace-level implementation — plan and execute cross-repo slices"
---

Load docs/requirements.json and docs/context.json (workspace-level).

## TASK — START WORKSPACE SLICE

### Step 1: Load Workspace State

1. Load `docs/requirements.json` — workspace topology, repos, features, cross_repo_contracts
2. Load `docs/context.json` — repo_state, slice_history, handoff, current_slice
3. If `current_slice` is set and not done, resume it. Otherwise select next from `execution.recommended_slices` or `next_slice`.

### Step 2: Plan the Slice

For the selected slice:

1. Identify `impacted_repos` — which repos in `workspace.repos` are affected.
2. For each impacted repo, inspect relevant source files via relative paths.
3. Determine implementation order: contract source repos first, then consumers.
4. Plan matching feature branches: `feature/S{xx}-{slug}` in all impacted repos.

Output the slice plan:

```
### Slice S{xx} — [goal]

Impacted repos: [list]
Implementation order: [ordered list with rationale]
Branches: feature/S{xx}-{slug} in [repos]

Tasks:
1. [repo-id]: [what to implement]
2. [repo-id]: [what to implement]

Acceptance criteria:
- [per-repo criteria]
- [integration criteria]
```

### Step 3: Execute

1. Create feature branches in all impacted repos.
2. Implement changes in dependency order (contracts first, consumers second).
3. Run per-repo checks via `repo_commands` as you go.
4. Update `repo_state` in context.json with branches and HEAD SHAs.
5. Delegate to subagents as needed: bridge-architect (design), bridge-coder (implement), bridge-debugger (fix failures).

### Step 4: Deliver

Present results with per-repo summary of changes made, tests passing, and evidence.

```
HUMAN:
1. [Per-repo verification: what to check in each impacted repo]
2. [Integration verification: what to test across repos]
3. Report issues or approve to proceed to gate
```

$ARGUMENTS
