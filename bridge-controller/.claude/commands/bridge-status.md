---
description: "Portfolio status — discover managed projects and summarize state"
---

Scan subdirectories for `.bridgeinclude` marker files to discover all managed projects.

For each discovered entry:
1. Read the `.bridgeinclude` to get type, description, platform, priority, and tags
2. If the folder has `docs/context.json`, read feature_status, current_slice, handoff, and blockers
3. If the folder has `docs/requirements.json`, read the project name and feature count

Group results by:
- **Standalone projects** (type = "project")
- **Workspaces** (type = "repo" entries sharing the same `workspace` value)

Output a concise portfolio status table:

| Project/Workspace | Priority | Status | Current Slice | Blockers |
|---|---|---|---|---|

For workspaces, show per-repo status underneath the workspace header.

After the table, list any cross-project concerns:
- Stale projects (context.json has old last_updated)
- Missing BRIDGE configuration (no docs/ or no CLAUDE.md/AGENTS.md)
- Active blockers
- Folders without `.bridgeinclude` that look like they might be projects (have a .git/)

Update `docs/portfolio.json` with the latest scan results.
