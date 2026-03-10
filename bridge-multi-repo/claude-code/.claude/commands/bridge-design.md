---
description: "Integrate a design document — decompose, assign to repos, plan cross-repo slices"
---

You are following BRIDGE v2.1 methodology in a multi-repo workspace.

The user is providing a design document (PRD, feature spec, API spec, or similar). Decompose it and integrate into workspace-level BRIDGE artifacts, assigning elements to specific repos.

## TASK — INTEGRATE CROSS-REPO DESIGN

### Step 1: Load Existing State

1. Load `docs/requirements.json` — note all existing IDs (highest Fxx, ATxx, Sxx), workspace topology, contracts
2. Load `docs/context.json` — feature_status, repo_state, active slices
3. Load `docs/decisions.md` if it exists
4. For impacted repos, inspect relevant source files

### Step 2: Analyze the Design Document

Parse and classify each element:

```
DESIGN ANALYSIS

Document: [title/source]

ELEMENTS FOUND:
[N] new features — assigned to repos: [repo-id list]
[N] extensions to existing features
[N] modifications to existing behavior
[N] new cross-repo contracts
[N] new architectural decisions
```

For each element, classify as:
- **NEW** — gets new Fxx IDs, specify target repo(s)
- **EXTEND** — adds to existing Fxx, specify which repo(s) affected
- **MODIFY** — changes existing behavior, identify impacted repos
- **CONTRACT** — new cross-repo contract or constraint

### Step 3: Cross-Repo Conflict Detection

```
CROSS-REPO CONFLICT REPORT

CONTRACT CONFLICTS:
- [New element conflicts with existing cross_repo_contracts]

DEPENDENCY CONFLICTS:
- [Repo A's change requires Repo B's change to land first]

SCOPE CONFLICTS:
- [Element contradicts existing scope]
```

If MODIFY elements or conflicts exist: STOP and wait for human confirmation.

### Step 4: Update docs/requirements.json

- Append new features continuing from highest Fxx
- New acceptance tests continuing from highest ATxx
- New slices continuing from highest Sxx
- Update `workspace.cross_repo_contracts` with new contracts
- Update `workspace.integration_acceptance_tests` with new integration tests
- NEVER overwrite existing features/tests/slices
- NEVER reuse existing IDs

### Step 5: Update docs/context.json

- Add new features to feature_status as "planned"
- Add recent_decision about the design integration
- Set next_slice if appropriate

### Step 6: Update docs/decisions.md

Record architectural decisions with source attribution.

### Step 7: Recommended Slice Ordering

```
RECOMMENDED SLICE ORDER

Phase 1 — Contract/Foundation (source repos):
  S[xx]: [goal] — repos: [list] — [why first]

Phase 2 — Consumer Implementation:
  S[xx]: [goal] — repos: [list] — [depends on Phase 1]

Phase 3 — Integration & Validation:
  S[xx]: [goal] — repos: [all impacted] — [E2E verification]
```

### Step 8: Output Integration Report

```
DESIGN INTEGRATION COMPLETE

Source: [design document]

Integrated:
- [N] new features: F[xx]-F[yy]
- [N] acceptance tests: AT[xx]-AT[yy]
- [N] slices: S[xx]-S[yy]
- [N] new cross-repo contracts
- [N] architectural decisions

Per-repo breakdown:
- [repo-id]: [N] features, [summary]
- [repo-id]: [N] features, [summary]

Files modified:
- docs/requirements.json
- docs/context.json
- docs/decisions.md
```

```
HUMAN:
1. Review the per-repo breakdown — correct assignment?
2. Review cross-repo contracts — complete?
3. Review slice ordering — dependencies correct?
4. Approve to start implementation with /bridge-start
```

$ARGUMENTS
