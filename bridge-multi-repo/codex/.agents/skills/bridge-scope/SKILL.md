---
name: Bridge Scope
description: "Phase 0: Scope a cross-repo feature, fix, or extension for a multi-repo workspace. Invoke with $bridge-scope in your prompt."
---

You are following the BRIDGE v2.1 methodology in a multi-repo workspace.

BRIDGE = Brainstorm -> Requirements -> Implementation Design -> Develop -> Gate -> Evaluate

## TASK — PHASE 0: SCOPE (Multi-Repo Workspace)

The user wants to add a feature, fix a bug, or extend functionality across one or more repos in the workspace.

### Step 1: Understand Current State

1. Load `docs/requirements.json` — workspace topology, repos, contracts, existing features.
2. Load `docs/context.json` — `repo_state`, `feature_status`, completed work.
3. For each repo in `workspace.repos`:
   - Check recent git activity (`git log --oneline -10`).
   - Inspect project structure: build files, src/ layout, test structure.
4. Targeted code inspection of areas likely affected by the requested change.
5. Note: existing tech stacks per repo, shared patterns, contract conventions, test conventions.

### Step 2: Scope the Change

Output format:

```
### Phase 0 — Scope Results (Multi-Repo)

#### Change Summary
[1-2 sentences: what changes and why]

#### Type
[feature | fix | refactor | extension | integration]

#### Impacted Repos
For each impacted repo:
- **[repo-id]** ([path])
  - Files likely affected: [list with brief reason]
  - Risk areas: [what could break in this repo]
  - Existing patterns to follow: [conventions in this repo]

#### Cross-Repo Impact
- **Contract changes:** [API/schema changes that cross repo boundaries]
- **Shared type changes:** [types/interfaces that must stay in sync]
- **Migration needs:** [data or schema migrations required across repos]
- **Merge ordering:** [which repo must merge first and why]

#### Files That MUST NOT Change
[Boundaries — per repo if needed]

#### Dependencies Added/Removed
[Per repo, if any]

#### Approach
[2-5 bullets: high-level implementation strategy, noting cross-repo coordination]

#### Acceptance Criteria (draft)
1. [Given/When/Then — per-repo and integration criteria]
2. [Edge cases to handle]
3. [What should NOT change in behavior]

#### Open Questions
[Anything the human needs to decide before proceeding]

#### Estimated Scope
[S/M/L — number of slices likely needed, which repos are touched per slice]
```

### Step 3: Human Handoff

```
HUMAN:
1. Review the impacted repos — are the boundaries correct?
2. Review the cross-repo impact — any missing contract dependencies?
3. Decide any open questions listed above
4. If this looks right, run: $bridge-design [paste this scope output or "proceed"]
5. If scope needs adjustment, tell me what to change
```

Now scan the workspace and scope this change:

The user will provide arguments inline with the skill invocation.
