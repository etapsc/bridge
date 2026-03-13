# BRIDGE v3 Vision

## Context

BRIDGE v2 delivered a solid methodology framework: 5 platform packs, 15 commands, 5 role-based agents, structured JSON artifacts, quality gates, and feedback loops. It works.

But real-world usage has surfaced several areas where the framework could do more without losing its lean philosophy.

## Findings

### 1. Agents lack domain awareness

It was found that a generic "coder" agent produces adequate but undifferentiated output regardless of whether the task is a React component, a database migration, or an infrastructure script. The agent follows methodology rules correctly but doesn't bring domain-specific knowledge — anti-patterns to avoid, checklists to follow, conventions that matter in a given stack. Users end up adding this context manually every time.

### 2. Agent tone is one-size-fits-all

It was found that different teams and projects benefit from different agent communication styles. A solo developer exploring a prototype wants agents that move fast and explain less. A team onboarding junior developers wants agents that explain reasoning and teach as they go. A production codebase with compliance requirements wants agents that default to skepticism and demand evidence. Currently, all agents behave identically regardless of context.

### 3. Script surface is fragmented

It was found that the current script naming creates confusion:

- `setup.sh` — creates a new project
- `add-bridge.sh` — adds BRIDGE to an existing project
- `install-orchestrators.sh` — installs controller and multi-repo packs
- `package.sh` — builds release archives (maintainer tool)

Users frequently run the wrong script or don't discover that a script exists. The distinction between "new project" and "add to existing" is not obvious from the names. The install script for advanced packs is completely separate with no discoverability from the main scripts.

### 4. Post-install customization requires manual editing

It was found that once a pack is installed, changing its configuration (e.g., adding domain-specific guidance or adjusting agent behavior) requires manually editing agent definition files and skill docs. There is no supported path for post-install customization, which means users either don't customize or make edits that get overwritten on updates.

### 5. Shell scripts have reached their ceiling

It was found that the tooling requirements have outgrown what shell scripting can comfortably deliver. `install-orchestrators.sh` already resorts to inline Python for JSON handling. The `customize` workflow will need structured file patching, config state tracking, and conditional logic that becomes fragile and unreadable in bash. Shell also limits the user experience to raw `read` prompts and flag parsing — no selection menus, no visual feedback, no discoverability. Additionally, shell scripts do not run on Windows without WSL, which is an unnecessary barrier for a developer tool.

### 6. Users must memorize flags and subcommands

It was found that even with a unified CLI, users would still need to know which flags exist, which combinations are valid, and what options are available for each parameter. A command-line interface with `--help` text is better than four separate scripts, but it still requires the user to read documentation before they can act. An interactive guided experience — where the tool presents choices and the user selects — removes this friction entirely.

## Proposed Changes

### Domain Specializations (skills)

Composable domain knowledge delivered as optional skill files. Each specialization contains checklists, anti-patterns, conventions, and review criteria for a specific stack domain. The orchestrator injects relevant specializations when delegating to agents based on slice context.

Candidate specializations:
- `frontend` — component architecture, hydration, accessibility, layout performance, state management
- `backend` — API design, N+1 queries, connection pooling, error handling patterns, auth flows
- `api` — contract design, versioning, pagination, rate limiting, OpenAPI alignment
- `data` — schema design, migration safety, query optimization, indexing strategy
- `infra` — IaC patterns, secret management, observability, deployment safety
- `mobile` — platform lifecycle, offline-first, battery/network awareness, app store constraints
- `security` — threat modeling, input validation depth, dependency auditing, secrets rotation

Specializations are selected during setup or added post-install. Multiple can be active simultaneously. They do not replace agents — they augment them.

### Personality Packs (project-wide tone)

A small set of preset behavioral profiles applied as thin overlays across all agents and roles. Each personality adjusts communication style, risk tolerance, and explanation depth.

Candidate personalities:

**strict** — Agents default to skepticism. Auditor demands overwhelming evidence. Coder covers every edge case. Architect challenges every abstraction. Brainstorm leans hard on kill criteria. Orchestrator enforces tight scope. Best for: production systems, regulated environments, teams that value rigor.

**balanced** — Default BRIDGE behavior, comparable to v2. Evidence-based but not adversarial. Pragmatic trade-offs. Standard methodology flow. Best for: most projects.

**mentoring** — Agents explain their reasoning. Auditor frames findings as teaching moments. Coder comments the "why" not just the "what". Architect walks through options with rationale. Brainstorm explores ideas generously before filtering. Best for: learning environments, junior developers, solo developers building intuition.

Personality is a single project-wide setting, not per-agent. Selected during setup, changeable post-install.

### Interactive TUI Binary (`bridge`)

Replace all shell scripts with a single compiled binary built in Go using the Charm.sh TUI ecosystem (`bubbletea`, `huh`, `lipgloss`). The binary is the entire BRIDGE tooling surface — no shell scripts, no runtime dependencies, no `python3` fallbacks.

**Why Go:**
- Single binary, no runtime. User downloads one file for their platform and runs it.
- Cross-compiles trivially: `GOOS=linux`, `GOOS=darwin`, `GOOS=windows` from one codebase.
- Charm.sh is the de facto standard for interactive CLI tools (used by GitHub CLI, lazygit, etc.).
- Go's `//go:embed` can bake pack templates directly into the binary if desired.
- `goreleaser` automates multi-platform builds and GitHub Release uploads.

**Interactive mode (default):**

When the user runs `bridge` with no arguments, the TUI guides them:

```
$ bridge

  BRIDGE v3

  What would you like to do?

  > New project
    Add to existing project
    Install orchestrator
    Customize project
    Pack archives (maintainer)
```

Selecting "New project" flows into:

```
  Platform pack:

  > Claude Code
    Codex
    RooCode Full
    RooCode Standalone
    OpenCode
```

Then:

```
  Personality:

    strict
  > balanced
    mentoring
```

Then:

```
  Specializations (space to toggle):

    [x] backend
    [x] api
    [ ] frontend
    [ ] data
    [ ] infra
    [ ] mobile
    [ ] security
```

Then:

```
  Project name: my-project█
  Target directory: .
```

The TUI validates inputs, shows a summary, and executes — no flags to memorize, no documentation to read first.

**Flag mode (scripting/CI):**

All TUI flows have equivalent flag-based invocations for automation:

```bash
bridge new --pack claude-code --personality strict --spec frontend,api --name "My Project"
bridge add --pack codex --personality mentoring --spec backend,data --target ./my-project
bridge orchestrator --type multi-repo --platform claude-code
bridge customize --personality strict
bridge customize --add-spec security
bridge customize --remove-spec data
bridge customize --list
bridge pack
```

When flags are provided, the TUI is bypassed and the command runs non-interactively. Partial flags open the TUI pre-filled with the provided values, prompting only for missing inputs.

**Pack content strategy — thin binary with download cache:**

The binary does not embed all pack templates. Instead:

- On first use, the binary downloads the required pack archive from GitHub Releases.
- Downloaded packs are cached in `~/.bridge/cache/` with version tracking.
- Subsequent runs use the cache. `bridge update` refreshes the cache.
- For air-gapped environments, users can pre-populate `~/.bridge/cache/` manually or point to a local mirror with `--source`.

This keeps the binary small (~5-8MB with TUI) while supporting offline use after first run.

**Distribution:**

```bash
# macOS
brew install etapsc/tap/bridge

# Linux (one-liner)
curl -fsSL https://get.bridge.dev | sh

# Windows
scoop install bridge
# or download .exe from GitHub Releases

# Manual (any platform)
# Download binary from https://github.com/etapsc/bridge/releases
```

### Personality and Specialization Mechanics

**At install time:**
- `bridge new --pack claude-code --personality strict --spec frontend,api`
- `bridge add --pack codex --personality mentoring --spec backend,data`

**Post-install:**
- `bridge customize --personality strict` — swaps vibe lines in all agent files
- `bridge customize --add-spec security` — copies specialization skill file into project

**Storage:**
- Personalities: shipped as `profiles/{strict,balanced,mentoring}.json` containing per-agent vibe lines keyed by agent name and role
- Specializations: shipped as `specializations/{frontend,backend,...}/SKILL.md` containing domain knowledge
- Active configuration tracked in `.bridge.json` at project root so `customize` knows current state and `bridge` can detect an existing BRIDGE project

**Agent file patching:**
- Personality vibe lines are injected between a pair of markers in agent files (e.g., `<!-- bridge:personality -->` ... `<!-- /bridge:personality -->`)
- This allows `customize` to find and replace without touching the rest of the agent definition
- Specialization skills are simply copied into the project's skill directory — no patching needed
- `.bridge.json` records which personality and specializations are active, enabling clean swaps and removals

## What Stays the Same

- 5 core agents (architect, coder, debugger, auditor, evaluator) — lean by design
- BRIDGE methodology phases (Brainstorm, Requirements, Implementation Design, Develop, Gate, Evaluate)
- JSON artifacts (requirements.json, context.json)
- 15 slash commands
- Quality gates and feedback loops
- Human handoff protocol
- 5 platform packs + advanced orchestrator packs
- Session continuity (resume/end)

## What This Enables

- Users get domain-aware agents without BRIDGE becoming a 100-agent catalog. The methodology backbone stays intact.
- Specializations are composable and community-contributable — anyone can write a `SKILL.md` for their stack.
- Personalities let teams tune BRIDGE to their working style without forking the entire pack.
- The TUI makes the entire toolkit discoverable from a single binary — no documentation required for first use.
- Windows users can use BRIDGE without WSL.
- CI/CD pipelines can use the same binary with flags, no interactive prompts.
- Air-gapped and enterprise environments are supported via local cache and `--source` override.

## Migration from v2

- Existing v2 projects continue to work unchanged. The pack files are the same format.
- `bridge customize` can be run in existing v2 project directories to add personalities and specializations retroactively.
- `.bridge.json` is created on first `bridge customize` or `bridge add` run — it does not need to exist for v2 packs to function.
- Shell scripts (`setup.sh`, `add-bridge.sh`, `install-orchestrators.sh`) remain in the repo for backward compatibility but are no longer the primary interface.

## Open Questions

1. Should specializations be versioned independently from the core packs?
2. Should `bridge customize` support user-defined specializations (not just shipped ones)?
3. Should `.bridge.json` also track which pack and version was installed, enabling `bridge update` to upgrade in place?
4. Should personality affect the methodology reference doc tone, or only agent definitions?
5. Should `bridge` auto-detect the current project's pack type (by looking for CLAUDE.md, AGENTS.md, .roomodes) and skip the pack selection step in `customize`?
6. What is the minimum Go version to target? (Affects `//go:embed` availability and Charm.sh compatibility.)
