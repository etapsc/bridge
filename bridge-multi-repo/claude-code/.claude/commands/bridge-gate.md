---
description: "Two-phase quality gate — per-repo checks then cross-repo integration"
---

## TASK — TWO-PHASE WORKSPACE GATE

### Step 1: Load State

1. Load `docs/context.json` — current_slice, repo_state, repo_commands
2. Load `docs/requirements.json` — acceptance_tests, workspace.integration_acceptance_tests, cross_repo_contracts
3. Identify impacted repos for the current slice.

### Step 2: Phase 1 — Repo Checks

For each impacted repo, run its checks from `repo_commands`:

| Repo | Test | Lint | Typecheck | Build | Result |
|------|------|------|-----------|-------|--------|

Record pass/fail for each. If any repo fails, Phase 1 is FAIL.

### Step 3: Phase 2 — Integration Checks

Run cross-repo checks:

1. **Contract compliance**: verify contracts in `cross_repo_contracts` are honored (source matches consumers)
2. **Type consistency**: shared types/interfaces match across repos
3. **Integration tests**: run tests from `integration_acceptance_tests`
4. **Migration compatibility**: if schema changes exist, verify migration order is valid
5. **Version alignment**: dependency versions referencing sibling repos are correct

| Check | Status | Notes |
|-------|--------|-------|
| Contract compliance | | |
| Type consistency | | |
| Integration tests | | |
| Migration compatibility | | |
| Version alignment | | |

### Step 4: Verdict

Gate is **PASS** only if both phases pass.

### Step 5: Produce Gate Report

Write `docs/gates-evals/gate-report.md`:

```
# Gate Report — S{xx}

Date: [today]
Verdict: [PASS / FAIL]

## Phase 1 — Repo Checks
[per-repo results table]

## Phase 2 — Integration Checks
[integration results table]

## Acceptance Test Evidence
[ATxx: evidence per test]

## Issues (if FAIL)
1. [what failed, which repo, how to fix]
```

```
HUMAN:
1. Review gate-report.md
2. If PASS: approve to proceed to next slice
3. If FAIL: review the issues and decide how to fix
```
