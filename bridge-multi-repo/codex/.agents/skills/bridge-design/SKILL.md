---
name: Bridge Design
description: Integrate a design document into a multi-repo BRIDGE workspace — decompose, assign to repos, plan cross-repo slices. Invoke with $bridge-design in your prompt.
---

You are following the BRIDGE v2.1 methodology in a multi-repo workspace.

The user is providing a design document (PRD, feature spec, architectural plan, etc.). Decompose it and integrate it into workspace-level BRIDGE artifacts, assigning elements to specific repos.

## TASK — INTEGRATE DESIGN (Multi-Repo)

### Step 1: Load Existing State

1. Load `docs/requirements.json` — note ALL existing IDs (highest Fxx, ATxx, Sxx, UFxx, Rxx), workspace topology, contracts.
2. Load `docs/context.json` — `feature_status`, `repo_state`, completed work, active slices.
3. Load `docs/decisions.md` — existing architectural decisions.
4. For each repo in `workspace.repos`: check recent git activity and inspect areas the design will affect.

### Step 2: Analyze the Design Document

Parse the provided design and classify each element, noting which repo each affects:

```
DESIGN ANALYSIS

Document: [title/source]
Type: [PRD | feature spec | version spec | architectural plan | API spec | other]

ELEMENTS FOUND:
[N] new features (no overlap with existing) — repos: [list]
[N] extensions to existing features (Fxx affected) — repos: [list]
[N] modifications to existing behavior — repos: [list]
[N] deprecations or removals — repos: [list]
[N] new architectural decisions
[N] new constraints or NFRs
[N] new cross-repo contracts or interfaces
```

For each element, classify as:
- **NEW** — no overlap with existing features, gets new Fxx IDs
- **EXTEND** — adds capability to existing Fxx, gets new ATxx under existing feature
- **MODIFY** — changes existing behavior, needs careful migration
- **DEPRECATE** — marks existing features for removal
- **CONSTRAINT** — new technical constraint or NFR
- **CONTRACT** — new or changed cross-repo contract/interface

### Step 3: Conflict Detection

```
CONFLICT REPORT

BREAKING CHANGES:
- [Fxx: what changes, which repos affected, what existing tests break]

CROSS-REPO CONFLICTS:
- [Contract X in repo-a conflicts with consumer in repo-b]

DEPENDENCY CONFLICTS:
- [New feature depends on Fxx which is currently blocked/incomplete in repo-x]

SCOPE CONFLICTS:
- [Design element X contradicts existing scope.out_of_scope or non_goals]
```

### Step 4: Human Confirmation Gate

If the design involves MODIFY, DEPRECATE, or CONTRACT elements, or if conflicts were found:
Present the Design Analysis and Conflict Report, then STOP and WAIT for confirmation.

If purely additive (only NEW/EXTEND, no conflicts): proceed but include the analysis.

### Step 5: Update docs/requirements.json

Apply changes following standard BRIDGE rules:
- NEW: append features continuing from highest Fxx, acceptance tests from highest ATxx.
- EXTEND: add acceptance tests to existing features.
- MODIFY: update descriptions, add regression tests.
- DEPRECATE: mark with `"deprecated": true` — never remove.
- CONTRACT: add to `cross_repo_contracts` with source and consumer repos.

**Per-repo assignment:** each feature and acceptance test should note which repos it affects.

### Step 6: Update docs/context.json

- Add new features to `feature_status` as `planned`.
- Set `next_slice` to first new slice.
- Update `repo_state` if repo assignments changed.
- Add `recent_decision` entry.

### Step 7: Update docs/decisions.md

Record architectural decisions, noting cross-repo implications:

```
YYYY-MM-DD: [Decision] - [Rationale] - Affects: [repo list] (Source: [design title])
```

### Step 8: Recommended Slice Ordering

Propose slice order accounting for cross-repo dependencies and merge order:

```
RECOMMENDED SLICE ORDER

Phase 1 — Foundation (contract source repos first):
  S[xx]: [goal] — repos: [list] — [why first]

Phase 2 — Consumer Updates:
  S[xx]: [goal] — repos: [list] — [depends on S[yy]]

Phase 3 — Integration:
  S[xx]: [goal] — repos: [list] — [cross-repo verification]

Phase 4 — Cleanup:
  S[xx]: [goal] — repos: [list] — [deprecation/removal]
```

### Step 9: Output Integration Report

```
DESIGN INTEGRATION COMPLETE

Source: [design document title]

Per-Repo Breakdown:
- [repo-id]: [N] features, [N] acceptance tests, [N] contract changes
[repeat per repo]

Integrated:
- [N] new features: F[xx]-F[yy]
- [N] extended features: [Fxx list]
- [N] modified features: [Fxx list]
- [N] deprecated features: [Fxx list]
- [N] new acceptance tests: AT[xx]-AT[yy]
- [N] new slices: S[xx]-S[yy]
- [N] new/updated contracts
- [N] architectural decisions recorded

Conflicts found: [N]
Breaking changes: [yes/no]

Files modified:
- docs/requirements.json — [summary]
- docs/context.json — [summary]
- docs/decisions.md — [N] decisions recorded
```

```
HUMAN:
1. Review the per-repo breakdown — correct assignments?
2. Review the slice ordering — does the merge order make sense?
3. If conflicts found: decide how to resolve before proceeding
4. To start implementation: $bridge-start S[xx]
```

The user will provide arguments inline with the skill invocation.
