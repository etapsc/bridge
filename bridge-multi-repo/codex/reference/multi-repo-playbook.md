# BRIDGE Multi-Repo Playbook

A guide for setting up and using the BRIDGE multi-repo pack to coordinate cross-repo design, coding, review, and sync across multiple repositories in a single workspace.

## Setup

### 1. Create the orchestrator folder

Create a folder alongside your repos to hold the multi-repo orchestrator:

```bash
cd ~/work/my-product          # parent folder containing your repos
mkdir bridge-orchestrator
cd bridge-orchestrator
tar -xzf bridge-multi-repo-codex.tar.gz
```

Result:

```
my-product/
  bridge-orchestrator/        <-- multi-repo pack (you are here)
    AGENTS.md
    .agents/
      skills/
        bridge-cross-design/SKILL.md
        bridge-cross-review/SKILL.md
        bridge-cross-sync/SKILL.md
        bridge-repo-status/SKILL.md
      procedures/
    .codex/
      config.toml
    docs/
      requirements.json       <-- workspace-level requirements
      context.json             <-- workspace-level state
    reference/
      multi-repo-playbook.md
  api/                         <-- your repos
  web/
  infra/
```

### 2. Configure workspace topology

Edit `docs/requirements.json` — fill in the `workspace` section:

```json
"workspace": {
  "topology": "multi-repo",
  "repos": [
    {
      "repo_id": "api",
      "path": "../api",
      "default_branch": "main",
      "owners": ["backend"]
    },
    {
      "repo_id": "web",
      "path": "../web",
      "default_branch": "main",
      "owners": ["frontend"]
    }
  ],
  "cross_repo_contracts": [
    "web consumes api via OpenAPI spec at api/openapi.yaml"
  ],
  "integration_acceptance_tests": [
    "End-to-end checkout flow across web + api"
  ]
}
```

### 3. Configure per-repo commands

Edit `docs/context.json` — fill in `repo_commands` so the orchestrator knows how to check each repo:

```json
"workspace": {
  "topology": "multi-repo",
  "repos": ["api", "web"]
},
"repo_commands": {
  "api": {
    "test": "cd ../api && npm test",
    "lint": "cd ../api && npm run lint",
    "build": "cd ../api && npm run build"
  },
  "web": {
    "test": "cd ../web && npm test",
    "lint": "cd ../web && npm run lint",
    "build": "cd ../web && npm run build"
  }
}
```

### 4. Verify

Open Codex in the orchestrator folder and run:

```
$bridge-repo-status
```

This checks that all repos exist at the declared paths and shows their git state.

## Skills

### $bridge-cross-design

**When to use:** You need to plan a feature or change that spans multiple repos — API contracts, shared schemas, migration strategies.

**What it does:**
1. Reads workspace topology and existing cross-repo contracts
2. Inspects relevant source files in impacted repos (API definitions, schemas, types)
3. Produces a design document covering: impacted repos, contract changes, migration strategy, acceptance criteria, risks
4. Saves approved designs to `docs/contracts/`

**Example:**
```
$bridge-cross-design Add a streaming endpoint — api exposes SSE, web consumes it, shared event types
```

### $bridge-cross-review

**When to use:** After implementing cross-repo changes, verify everything is consistent before merging.

**What it does:**
1. Reads active feature branches from `repo_state` in context.json
2. Reviews diffs across repos for:
   - Type/interface consistency
   - API contract compliance (OpenAPI, protobuf, GraphQL)
   - Dependency version alignment
   - Migration sequencing
3. Outputs a consistency verdict: CONSISTENT or ISSUES FOUND with fix instructions

**Example:**
```
$bridge-cross-review              → review all repos with active feature branches
$bridge-cross-review api web      → review specific repos only
```

### $bridge-cross-sync

**When to use:** A contract or shared type changed in one repo and needs to be propagated to consumers.

**What it does:**
1. Identifies sync targets — either user-specified or detected by scanning for drift against declared contracts
2. Reads the source definition and consumer's current copy
3. Shows the diff and applies after user approval
4. Updates `repo_state` in context.json

**Example:**
```
$bridge-cross-sync                    → scan all contracts for drift
$bridge-cross-sync openapi.yaml       → sync specific contract from source to consumers
```

### $bridge-repo-status

**When to use:** Check workspace health — are repos on the right branches, is context.json up to date, any uncommitted changes.

**What it does:**
1. Checks each repo: current branch, clean/dirty, latest commit
2. Compares actual state against `repo_state` in context.json
3. Shows coordination health: matching branches, state drift, uncommitted changes
4. Offers to update context.json if drift is detected

**Example:**
```
$bridge-repo-status
```

## Example Workflows

### New multi-repo feature (end to end)

A feature that requires changes in both api and web repos.

```
1. Open Codex in the orchestrator folder
2. $bridge-cross-design Add user preferences API + UI
   → Produces design: api gets /preferences endpoint, web gets settings page,
     shared types in api/openapi.yaml
   → Review and approve the design

3. $bridge-start
   → Plans S01 with impacted_repos: [api, web]
   → Creates feature/S01-user-prefs branches in both repos
   → Implements api changes first (contract source), then web (consumer)
   → Updates repo_state in context.json with branches and SHAs

4. $bridge-cross-review
   → Verifies types match, API contract honored, no version drift
   → Verdict: CONSISTENT

5. Test using the HUMAN: block instructions
   → Report issues → agent fixes in current slice
   → Approve → proceeds to gate

6. $bridge-gate
   → Repo phase: runs api tests, web tests via repo_commands
   → Integration phase: runs E2E from integration_acceptance_tests
   → PASS / FAIL

7. Merge: api first (contract source), then web
```

### Contract change propagation

The api repo updated its OpenAPI spec and consumers need to sync.

```
1. $bridge-repo-status
   → Shows api is on main with new commits, web is behind

2. $bridge-cross-sync openapi.yaml
   → Detects drift: api/openapi.yaml changed, web's generated types are stale
   → Shows diff of what will change in web
   → Approve → applies changes to web

3. $bridge-cross-review
   → Verifies web's types now match api's spec
   → CONSISTENT
```

### Cross-repo code review before merge

Both repos have feature branches with related changes, ready for review.

```
1. $bridge-repo-status
   → Shows api and web both on feature/S03-auth branches, clean

2. $bridge-cross-review
   → Reviews diffs on both branches
   → Checks: auth middleware in api matches token validation in web
   → Checks: shared auth types are identical
   → ISSUES FOUND: web uses old token format, api expects new
   → Fix instructions provided

3. Fix the issue in web, commit

4. $bridge-cross-review
   → CONSISTENT

5. Proceed to gate
```

### Resuming work on a multi-repo slice

New session, picking up where you left off.

```
1. Open Codex in the orchestrator folder
2. Read docs/context.json → see current_slice, repo_state, handoff

3. $bridge-repo-status
   → Verify repos are still on the right branches, no unexpected changes

4. Continue implementation on the current slice
   → The orchestrator uses repo_state to know which repos to work in
```

## Relationship to BRIDGE Controller

| | BRIDGE Controller | BRIDGE Multi-Repo |
|---|---|---|
| **Lives at** | Root of all projects (`~/work/`) | Alongside repos in a workspace |
| **Scope** | All projects in the portfolio | One multi-repo product |
| **Does coding?** | No — organizational only | Yes — cross-repo design, sync, implementation |
| **Discovery** | Scans for `.bridgeinclude` markers | Reads `workspace.repos` from requirements.json |
| **Skills** | status, init-project, sync | cross-design, cross-review, cross-sync, repo-status |
| **Gate** | N/A | Two-phase: per-repo + integration |

You can use both together: the controller sees the workspace at a strategic level (priority, status), while the multi-repo pack handles the actual cross-repo coding work inside the workspace.
