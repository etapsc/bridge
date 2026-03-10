# BRIDGE Controller Guide

The BRIDGE Controller is a meta-orchestrator that sits at the root of your project folders and manages a portfolio of BRIDGE-enabled projects. It does not write application code — it coordinates, reviews, prioritizes, and scaffolds BRIDGE configurations for lower-level coding agents.

## Setup

### 1. Extract the controller pack

Extract `bridge-controller.tar.gz` into your root working directory — the folder that contains (or will contain) all your projects:

```bash
cd ~/work                  # or wherever your projects live
tar -xzf bridge-controller.tar.gz
```

This creates:

```
~/work/
  CLAUDE.md                          # controller instructions
  .claude/
    commands/
      bridge-status.md               # portfolio status
      bridge-init-project.md         # scaffold BRIDGE into a child project
      bridge-sync.md                 # sync state from child projects
    rules/
      controller.md                  # controller guardrails
  docs/
    portfolio.json                   # cross-project state (starts empty)
```

### 2. Mark projects with .bridgeinclude

Drop a `.bridgeinclude` file into each subfolder the controller should manage:

```bash
# Standalone project
cat > my-project/.bridgeinclude << 'EOF'
type = "project"
description = "My standalone project"
platform = "claude-code"
priority = "high"
tags = ["backend", "api"]
EOF

# Repo in a multi-repo workspace
cat > my-product/api/.bridgeinclude << 'EOF'
type = "repo"
description = "API service"
workspace = "my-product"
platform = "claude-code"
EOF
```

### 3. Verify discovery

Open Claude Code in your root directory and run:

```
/bridge-status
```

The controller scans for `.bridgeinclude` markers and shows what it found.

## .bridgeinclude Reference

Each `.bridgeinclude` is a TOML file placed in a managed folder. It describes that folder.

| Field | Required | Values | Description |
|-------|----------|--------|-------------|
| `type` | yes | `"project"`, `"repo"` | Standalone project or part of a multi-repo workspace |
| `description` | yes | string | Short description of the project/repo |
| `platform` | no | `"claude-code"`, `"codex"`, `"opencode"`, `"roocode-full"`, `"roocode-standalone"` | Which BRIDGE pack this project uses |
| `workspace` | for repos | string | Groups repos into a workspace (same value = same workspace) |
| `priority` | no | `"high"`, `"medium"`, `"low"` | For roadmap and prioritization |
| `tags` | no | string array | Free-form tags for grouping/filtering |

## Commands

### /bridge-status

**When to use:** Get a portfolio overview. See what's active, stale, or blocked across all projects.

**What it does:**
1. Scans subdirectories for `.bridgeinclude` markers
2. Reads each project's `docs/context.json` for status, current slice, blockers
3. Reads each project's `docs/requirements.json` for project name and feature count
4. Outputs a status table grouped by standalone projects and workspaces
5. Flags stale projects, missing BRIDGE configs, and active blockers
6. Updates `docs/portfolio.json` with scan results

**Example output:**

```
| Project/Workspace   | Priority | Status    | Current Slice           | Blockers |
|---------------------|----------|-----------|-------------------------|----------|
| my-project          | high     | active    | S03 — auth middleware    | none     |
| sdk-tools           | low      | idle      | —                       | none     |
| **my-product**      |          |           |                         |          |
|   api               | high     | active    | S05 — stream endpoint   | none     |
|   web               | medium   | blocked   | S05 — stream UI         | api S05  |
```

### /bridge-init-project

**When to use:** Set up BRIDGE in a new or existing child project folder.

**What it does:**
1. Creates a `.bridgeinclude` marker in the target folder
2. Scaffolds the full BRIDGE configuration for the chosen platform (CLAUDE.md, .claude/, docs/, etc.)
3. Creates `docs/requirements.json` and `docs/context.json` templates

**Usage:** Run `/bridge-init-project` and specify the target path, platform, and project name when prompted.

### /bridge-sync

**When to use:** After working in child projects, pull their current state into the portfolio view.

**What it does:**
1. Scans for `.bridgeinclude` markers
2. Reads each project's `docs/context.json` for current state
3. Detects drift: stale contexts, mismatched branches in workspaces, unresolved blockers
4. Updates `docs/portfolio.json` with latest data
5. Reports how many projects were scanned and any issues found

## Example Workflows

### Starting from scratch

You have an empty work directory and want to set up multiple projects with BRIDGE.

```
1. cd ~/work
2. tar -xzf bridge-controller.tar.gz
3. Open Claude Code in ~/work
4. /bridge-init-project       → creates my-project/ with BRIDGE (Claude Code pack)
5. /bridge-init-project       → creates another-project/ with BRIDGE
6. /bridge-status             → see both projects in the portfolio

Now switch to a child project to do actual work:
7. cd my-project
8. Open Claude Code in my-project/
9. /bridge-brainstorm         → start the BRIDGE workflow inside the project
```

### Adding the controller to existing projects

You already have projects in ~/work but no controller.

```
1. cd ~/work
2. tar -xzf bridge-controller.tar.gz
3. Drop .bridgeinclude markers into existing project folders:
   echo 'type = "project"\ndescription = "API server"' > api-server/.bridgeinclude
   echo 'type = "project"\ndescription = "Dashboard"' > dashboard/.bridgeinclude
4. Open Claude Code in ~/work
5. /bridge-status             → discovers both projects, reads their docs/context.json
6. /bridge-sync               → pulls state into docs/portfolio.json
```

### Managing a multi-repo workspace

You have a product that spans api/, web/, and infra/ repos.

```
1. Drop .bridgeinclude markers:
   echo 'type = "repo"\nworkspace = "my-product"\ndescription = "API"' > api/.bridgeinclude
   echo 'type = "repo"\nworkspace = "my-product"\ndescription = "Web"' > web/.bridgeinclude
   echo 'type = "repo"\nworkspace = "my-product"\ndescription = "Infra"' > infra/.bridgeinclude

2. Open Claude Code in ~/work
3. /bridge-status             → shows "my-product" workspace with 3 repos

Note: The controller sees the workspace at a strategic level.
For cross-repo coding (designs, syncs, reviews), use the bridge-multi-repo
pack in a dedicated orchestrator folder alongside the repos.
```

### Priority and roadmap review

You have 6 projects with different priorities and want advice on sequencing.

```
1. Set priorities in each .bridgeinclude:
   echo 'type = "project"\npriority = "high"\ndescription = "Ship this week"' > urgent-fix/.bridgeinclude
   echo 'type = "project"\npriority = "low"\ndescription = "Nice to have"' > side-project/.bridgeinclude

2. /bridge-status             → table sorted/tagged by priority
3. Ask: "Given the current status and priorities, what should I work on next?"
   The controller reads all project states and advises on sequencing.
```

## What the Controller Does NOT Do

- **No application code.** It never modifies source code in child projects.
- **No tests or builds.** It doesn't run test suites, linters, or build commands.
- **No cross-repo coding.** For cross-repo design, sync, and implementation, use the `bridge-multi-repo` pack in a dedicated workspace folder.
- **No replacement.** Each child project keeps its own BRIDGE pack and coding agent. The controller sits above.
