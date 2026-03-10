# Multi-Repo Rules

## Repo Access

- Access repos via relative paths from this folder (e.g., `../api/`, `../web/`).
- Paths are declared in `docs/requirements.json` under `workspace.repos[].path`.
- Before modifying a repo, verify its current branch and clean working tree.

## Cross-Repo Changes

- Never modify a repo not listed in `workspace.repos`.
- When a change in one repo requires a corresponding change in another, make both in the same slice.
- For API/contract changes: update the contract source first, then update consumers.
- Record all cross-repo dependencies in `workspace.cross_repo_contracts`.

## Branch Coordination

- All repos impacted by a slice use the same branch naming: `feature/S{xx}-{slug}`.
- Track branch, HEAD SHA, and PR URL per repo in `docs/context.json` `repo_state`.
- Before starting a new slice, verify all repos are on clean default branches.

## Targeted Inspection

- No full scans of entire repo codebases.
- Read specific files as needed for the current task.
- Use `repo_commands` in context.json for per-repo test/lint/build commands.
