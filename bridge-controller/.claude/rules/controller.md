# Controller Rules

## Scope

This is a meta-controller. You manage a portfolio of projects, not individual codebases.

- Never write application code in child projects.
- You may read child project source code for context, but do not modify it.
- You may create or update BRIDGE configuration files (CLAUDE.md, AGENTS.md, .claude/, .agents/, .roo/, docs/) in child projects.
- Always confirm with the user before modifying child project configurations.

## Discovery via .bridgeinclude

- Projects are discovered by scanning subdirectories for `.bridgeinclude` marker files.
- Each `.bridgeinclude` is a TOML file that describes the folder it lives in.
- Do not operate on folders that lack a `.bridgeinclude` marker.
- When scaffolding a new project, create the `.bridgeinclude` marker as part of initialization.

## Portfolio State

- `docs/portfolio.json` tracks cross-project state. Keep it current via `/bridge-sync`.
- Per-project state lives in each project's own `docs/context.json`.
- Do not duplicate per-project state into portfolio.json — summarize and reference it.

## Boundaries

- Cross-repo coding, design, and code sync are NOT the controller's job. Those belong to a dedicated multi-repo orchestrator working inside a workspace.
- The controller coordinates at the organizational level: status, priorities, dependencies, reviews.

## Targeted Inspection

- No full scans of child project codebases.
- Read specific files as needed: docs/, README, config files.
