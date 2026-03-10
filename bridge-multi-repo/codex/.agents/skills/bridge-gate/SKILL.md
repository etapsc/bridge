---
name: Bridge Gate
description: Two-phase quality gate — per-repo checks then cross-repo integration. Invoke with $bridge-gate in your prompt.
---

Run the workspace quality gate. Two phases must both pass.

## Steps

### Phase 1 — Repo Checks

For each impacted repo (from the current slice's `impacted_repos`):

1. Read the repo's `repo_commands` from `docs/context.json`.
2. Run each command in the repo directory:
   - **test** — unit and integration tests
   - **lint** — linter checks
   - **typecheck** — type checking (if applicable)
   - **build** — production build
3. Record per-repo results: PASS or FAIL with output.

### Phase 2 — Integration Checks

1. Load `docs/requirements.json` for `integration_acceptance_tests` and `cross_repo_contracts`.
2. Run cross-repo checks:
   - **Contract validation** — source definitions match consumer usage across repos.
   - **Type consistency** — shared types/interfaces are identical across repos.
   - **E2E tests** — if integration test commands are defined, run them.
   - **Migration compatibility** — schema versions are compatible across repos.
3. Record integration results: PASS or FAIL with details.

### Gate Verdict

Gate is **PASS** only if ALL Phase 1 repo checks AND ALL Phase 2 integration checks pass.

Produce `docs/gates-evals/gate-report.md`:

```
### Gate Report — S{xx}

**Date:** YYYY-MM-DD
**Verdict:** PASS | FAIL

#### Phase 1 — Repo Checks

| Repo | Test | Lint | Typecheck | Build | Result |
|---|---|---|---|---|---|
[One row per impacted repo]

#### Phase 2 — Integration Checks

| Check | Status | Details |
|---|---|---|
| Contract validation | PASS/FAIL | [details] |
| Type consistency | PASS/FAIL | [details] |
| E2E tests | PASS/FAIL/N/A | [details] |
| Migration compatibility | PASS/FAIL/N/A | [details] |

#### Failures (if any)
1. [Repo/check]: [what failed and why]

#### ATxx Evidence
- AT{xx}: [PASS/FAIL — evidence summary]
```

```
HUMAN:
1. Review the gate report — any false failures?
2. If FAIL: fix the failures, then re-run $bridge-gate
3. If PASS: proceed to evaluation or next slice
```
