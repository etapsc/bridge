---
name: Bridge Start
description: Start workspace-level BRIDGE implementation — plan and execute cross-repo slices. Invoke with $bridge-start in your prompt.
---

Load workspace `docs/requirements.json` and `docs/context.json`.

Plan and execute the next workspace-level slice. Start with the first recommended slice or the slice indicated in `context.json` `next_slice`.

## Steps

1. Load `docs/requirements.json` — workspace topology (`workspace.repos`), features, contracts, slices.
2. Load `docs/context.json` — `repo_state`, `feature_status`, `next_slice`, handoff notes.
3. Identify the target slice (from `next_slice` or first `planned` slice).
4. Determine `impacted_repos` for the slice from workspace topology.
5. For each impacted repo (via relative paths from `workspace.repos[].path`):
   - Verify the repo exists and is clean (`git status`).
   - Create the feature branch: `feature/S{xx}-{slug}`.
6. Implement changes in dependency order:
   - **Contract source repos first** — update API definitions, shared schemas, protobuf/OpenAPI specs.
   - **Consumer repos second** — update client code, types, tests to match new contracts.
7. For each impacted repo, run its `repo_commands` (test, lint, typecheck, build) to verify.
8. Track per-repo evidence:
   - Tests passing, lint clean, build succeeding.
   - Branch name, HEAD SHA.
9. Update `docs/context.json`:
   - Set feature status to `in-progress`.
   - Update `repo_state` with branch, SHA, and evidence per repo.
10. Reference `.agents/procedures/` if applicable for detailed slice execution steps.

```
HUMAN:
1. Verify the impacted repos and branch names are correct
2. Review the implementation order — contract source before consumers
3. Run integration checks if cross-repo contracts changed
4. Feed back any issues or approve to proceed to gate
```

The user will provide arguments inline with the skill invocation.
