---
description: "Workspace status — per-repo state, branches, and coordination health"
---

Show the current state of all repos in the workspace.

Steps:

1. Load `docs/requirements.json` for workspace topology.
2. Load `docs/context.json` for `repo_state`, `repo_commands`, current slice, and handoff.
3. For each repo in the workspace:
   - Check if the repo path exists and is a git repo.
   - Read current branch, clean/dirty status, latest commit.
   - Compare against `repo_state` in context (detect drift).
   - If the repo has its own `docs/context.json`, read its status.
4. Output:

```
### Workspace Status — [Workspace Name]

| Repo | Branch | Status | Last Commit | PR |
|---|---|---|---|---|

#### Current Slice: S{xx} — [goal]
Impacted repos: [list]

#### Coordination Health
- [ ] All impacted repos on matching feature branches
- [ ] repo_state in context.json matches reality
- [ ] No uncommitted changes in impacted repos

#### Issues
- [Any drift, stale state, or coordination problems]
```

5. If drift is detected between context.json `repo_state` and actual repo state, offer to update context.json.