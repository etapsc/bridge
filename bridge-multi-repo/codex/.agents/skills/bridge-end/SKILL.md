---
name: Bridge End
description: End workspace session — save cross-repo state and handoff notes. Invoke with $bridge-end in your prompt.
---

Wrap up the current workspace session. Persist all state for the next session.

## Steps

1. Load `docs/context.json` for current state.
2. For each repo in `workspace.repos`:
   - Check current branch, clean/dirty status, HEAD SHA.
   - Check for open PRs on feature branches.
   - Update `repo_state` entry with branch, SHA, PR URL, and status.
3. Update `docs/context.json`:
   - `feature_status` — reflect current state of all active features.
   - `repo_state` — per-repo branch, SHA, PR URL, build status.
   - `handoff.in_progress` — what was being worked on.
   - `handoff.next_steps` — what to do next session.
   - `handoff.blockers` — any blocking issues.
   - `handoff.notes` — anything the next session needs to know.
4. Log significant decisions to `docs/decisions.md`:

```
YYYY-MM-DD: [Decision] - [Rationale] (Session wrap-up)
```

5. Output session summary:

```
### Session Summary

#### Work Completed
- [What was done, per repo]

#### Repo State
| Repo | Branch | SHA | Clean | PR |
|---|---|---|---|---|
[Current state of each active repo]

#### Open Items
- [Anything unfinished or blocked]

#### Next Session
- [Recommended first action for next session]
```

```
HUMAN:
1. Review the session summary — anything missing?
2. Verify handoff notes capture what you'd want to remember next time
3. To resume later: $bridge-resume
```
