---
description: "Scope a cross-repo feature, fix, or extension"
---

You are following BRIDGE v2.1 methodology in a multi-repo workspace.

## TASK — SCOPE CROSS-REPO CHANGE

The user wants to add a feature, fix a bug, or extend functionality that may span multiple repos.

### Step 1: Understand Workspace State

1. Load `docs/requirements.json` — workspace topology, repos, existing features, contracts
2. Load `docs/context.json` — repo_state, current work, handoff
3. For each repo, briefly inspect: project structure, recent git activity, relevant source files

### Step 2: Scope the Change

Output format:

```
### Phase 0 — Cross-Repo Scope Results

#### Change Summary
[1-2 sentences: what changes and why]

#### Type
[feature | fix | refactor | extension | integration]

#### Impacted Repos
| Repo | Impact | Files Affected | Risk |
|------|--------|----------------|------|
[per-repo breakdown]

#### Cross-Repo Impact
- **Contract changes:** [API/schema/protocol changes needed]
- **Shared types:** [types that must stay in sync across repos]
- **Migration needs:** [data/schema migrations, rollout order]
- **Merge ordering:** [which repo must merge first]

#### Per-Repo Details

**[repo-id]:**
- Files likely affected: [list]
- Existing patterns to follow: [conventions in this repo]
- Risk areas: [what could break]

[repeat for each impacted repo]

#### Acceptance Criteria (draft)
1. [Per-repo criteria]
2. [Integration criteria — what must work across repos]

#### Open Questions
[Anything the human needs to decide before proceeding]

#### Estimated Scope
[S/M/L — number of slices, repos touched, complexity]
```

### Step 3: Human Handoff

```
HUMAN:
1. Review the impacted repos — are the boundaries correct?
2. Review the cross-repo impact — any missing contracts or dependencies?
3. Decide any open questions
4. If this looks right, run: /bridge-design [paste scope output or "proceed"]
5. If scope needs adjustment, tell me what to change
```

$ARGUMENTS
