# Evaluation Scenarios

Generated: 2026-03-13
Project: BRIDGE v3 Toolkit
Gate Status: PASS (2026-03-13, F16-F19 — 16 Go tests, 45 smoke tests, 82 E2E assertions, 5 cross-compile targets)

## How to Use

1. Work through scenarios in order. Each scenario is self-contained.
2. Execute each step, verify the expected result.
3. Mark the checklist items as you go.
4. Fill out the feedback form in docs/gates-evals/feedback-template.md when done.
5. Time estimate: 45-60 minutes for all scenarios.
6. Optional helper: `bash tests/e2e/validate-eval-scenarios.sh` runs the automatable checks, pauses for the interactive `setup.sh` scenarios on a real TTY, and can launch the live CLI scenario when a supported agent is installed.

Prerequisites:
- Terminal with bash
- The BRIDGE repo cloned locally
- For platform-specific tests: Claude Code CLI, Codex CLI, OpenCode CLI, or RooCode extension installed (test whichever you have)

---

## Scenario 1: Setup Script -- Full Pack (F01, F05, AT01, UF01)

**Goal:** Verify setup.sh creates a working RooCode Full project from scratch.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./setup.sh --name "Eval Full" --pack full -o /tmp/bridge-eval`
   - Expected: Script prints summary, creates `/tmp/bridge-eval/eval-full/` directory, lists files.
2. Check directory structure: `ls /tmp/bridge-eval/eval-full/.roo/commands/ | wc -l`
   - Expected: 15 command files.
3. Check skills: `ls /tmp/bridge-eval/eval-full/.roo/skills/ | wc -l`
   - Expected: 6 skill directories.
4. Check placeholder replacement: `grep -r '{{PROJECT_NAME}}' /tmp/bridge-eval/eval-full/`
   - Expected: No output (all placeholders replaced).
5. Verify project name appears: `grep 'Eval Full' /tmp/bridge-eval/eval-full/docs/requirements.json`
   - Expected: Project name "Eval Full" appears in the file.
6. Check docs templates: `ls /tmp/bridge-eval/eval-full/docs/`
   - Expected: context.json, decisions.md, human-playbook.md, requirements.json all present.
7. Check .roomodes exists: `cat /tmp/bridge-eval/eval-full/.roomodes | head -5`
   - Expected: YAML content with mode definitions.

### Checklist
- [ ] setup.sh exits successfully
- [ ] 15 command files present
- [ ] 6 skill directories present
- [ ] No unreplaced {{PROJECT_NAME}} placeholders
- [ ] Project name appears in docs files
- [ ] docs/ templates present (4 files)
- [ ] .roomodes file exists and is valid YAML

---

## Scenario 2: Setup Script -- Claude Code Pack (F03, F05, AT03, UF01)

**Goal:** Verify setup.sh creates a working Claude Code project.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./setup.sh --name "Eval Claude" --pack claude-code -o /tmp/bridge-eval`
   - Expected: Script succeeds, creates `/tmp/bridge-eval/eval-claude/`.
2. Check CLAUDE.md: `head -3 /tmp/bridge-eval/eval-claude/CLAUDE.md`
   - Expected: Contains "Eval Claude" in the header.
3. Check commands: `ls /tmp/bridge-eval/eval-claude/.claude/commands/ | wc -l`
   - Expected: 15 command files.
4. Check agents: `ls /tmp/bridge-eval/eval-claude/.claude/agents/`
   - Expected: 5 agent files (bridge-architect, bridge-auditor, bridge-coder, bridge-debugger, bridge-evaluator).
5. Check skills: `ls /tmp/bridge-eval/eval-claude/.claude/skills/ | wc -l`
   - Expected: 6 skill directories.
6. Check placeholder: `grep -r '{{PROJECT_NAME}}' /tmp/bridge-eval/eval-claude/`
   - Expected: No output.

### Checklist
- [ ] setup.sh exits successfully
- [ ] CLAUDE.md exists with correct project name
- [ ] 15 command files in .claude/commands/
- [ ] 5 agent files in .claude/agents/
- [ ] 6 skill directories in .claude/skills/
- [ ] No unreplaced placeholders

---

## Scenario 3: Setup Script -- Codex Pack (F04, F05, AT04, UF01)

**Goal:** Verify setup.sh creates a working Codex project.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./setup.sh --name "Eval Codex" --pack codex -o /tmp/bridge-eval`
   - Expected: Script succeeds, creates `/tmp/bridge-eval/eval-codex/`.
2. Check AGENTS.md: `head -3 /tmp/bridge-eval/eval-codex/AGENTS.md`
   - Expected: Contains "Eval Codex".
3. Check workflow skills: `ls /tmp/bridge-eval/eval-codex/.agents/skills/ | wc -l`
   - Expected: 15 skill directories (one per command).
4. Check procedures: `ls /tmp/bridge-eval/eval-codex/.agents/procedures/ | wc -l`
   - Expected: 6 procedure files.
5. Check config: `cat /tmp/bridge-eval/eval-codex/.codex/config.toml`
   - Expected: Valid TOML configuration.
6. Check placeholder: `grep -r '{{PROJECT_NAME}}' /tmp/bridge-eval/eval-codex/`
   - Expected: No output.

### Checklist
- [ ] setup.sh exits successfully
- [ ] AGENTS.md exists with correct project name
- [ ] 15 skill directories in .agents/skills/
- [ ] 6 procedure files in .agents/procedures/
- [ ] .codex/config.toml present and valid
- [ ] No unreplaced placeholders

---

## Scenario 4: Setup Script -- Standalone Pack (F02, F05, AT02)

**Goal:** Verify standalone pack works without external rules/skills.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./setup.sh --name "Eval Standalone" --pack standalone -o /tmp/bridge-eval`
   - Expected: Script succeeds.
2. Check commands are self-contained: `wc -l /tmp/bridge-eval/eval-standalone/.roo/commands/bridge-start.md`
   - Expected: Significantly more lines than a thin command (the prompt is embedded).
3. Verify NO skills directory: `ls /tmp/bridge-eval/eval-standalone/.roo/skills/ 2>/dev/null && echo "EXISTS" || echo "NONE"`
   - Expected: "NONE" -- standalone packs have no external skills.
4. Check 15 commands present: `ls /tmp/bridge-eval/eval-standalone/.roo/commands/ | wc -l`
   - Expected: 15.

### Checklist
- [ ] setup.sh exits successfully
- [ ] Commands contain embedded prompts (not thin delegates)
- [ ] No .roo/skills/ directory
- [ ] 15 command files present

---

## Scenario 5: Setup Script -- OpenCode Pack (F11, F05, AT11)

**Goal:** Verify setup.sh creates a working OpenCode project.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./setup.sh --name "Eval OpenCode" --pack opencode -o /tmp/bridge-eval`
   - Expected: Script succeeds.
2. Check AGENTS.md: `head -3 /tmp/bridge-eval/eval-opencode/AGENTS.md`
   - Expected: Contains "Eval OpenCode".
3. Check commands: `ls /tmp/bridge-eval/eval-opencode/.opencode/commands/ | wc -l`
   - Expected: 15.
4. Check skills: `ls /tmp/bridge-eval/eval-opencode/.opencode/skills/ | wc -l`
   - Expected: 6.
5. Check agents: `ls /tmp/bridge-eval/eval-opencode/.opencode/agents/ | wc -l`
   - Expected: 5.

### Checklist
- [ ] setup.sh exits successfully
- [ ] AGENTS.md present with project name
- [ ] 15 commands, 6 skills, 5 agents present
- [ ] No unreplaced placeholders

---

## Scenario 6: Setup Script -- Interactive Mode (F05)

**Goal:** Verify setup.sh works in interactive mode (no flags).

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./setup.sh`
2. When prompted for pack, enter: `3` (claude-code)
3. When prompted for name, enter: `Interactive Test`
4. When prompted for output directory, press Enter (accept default `.`)
   - Expected: Project created at `./interactive-test/`.
5. Verify: `ls ./interactive-test/CLAUDE.md`
   - Expected: File exists.
6. Clean up: `rm -rf ./interactive-test`

### Checklist
- [ ] Interactive prompts appear correctly
- [ ] Pack selection by number works
- [ ] Project created in correct location
- [ ] Cleanup successful

---

## Scenario 7: Setup Script -- Error Handling (F05)

**Goal:** Verify setup.sh handles bad input gracefully.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./setup.sh --pack invalid-pack --name "Test" -o /tmp/bridge-eval`
   - Expected: Error message about invalid pack, non-zero exit code.
2. Run: `./setup.sh --pack full --name "Eval Full" -o /tmp/bridge-eval`
   - Expected: Error about directory already existing (from Scenario 1), prompt to overwrite.
   - Enter: `N` to decline.
   - Expected: "Aborted." message.

### Checklist
- [ ] Invalid pack name produces clear error
- [ ] Existing directory detected, overwrite prompt shown
- [ ] Declining overwrite aborts cleanly

---

## Scenario 8: Package Rebuild (F10, AT10)

**Goal:** Verify package.sh rebuilds all archives from source folders.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Note archive timestamps: `ls -la *.tar.gz | head -5`
2. Run: `./package.sh`
   - Expected: Lists each archive as it is built. No errors.
3. Count archives: `ls *.tar.gz | wc -l`
   - Expected: 9 archives (full, standalone, claude-code, codex, opencode, controller, multi-repo-claude-code, multi-repo-codex, dual-agent).
4. Check sizes are reasonable: `ls -la *.tar.gz`
   - Expected: All archives > 1 KB. Core packs 17-23 KB, controller ~6 KB, multi-repo ~24-28 KB, dual-agent ~5 KB.
5. Verify timestamps updated: `ls -la *.tar.gz | head -5`
   - Expected: Timestamps are now current.
6. Verify one archive extracts correctly:
   ```
   mkdir /tmp/bridge-pkg-test && tar -xzf bridge-full.tar.gz -C /tmp/bridge-pkg-test
   ls /tmp/bridge-pkg-test/.roo/commands/ | wc -l
   rm -rf /tmp/bridge-pkg-test
   ```
   - Expected: 15 command files extracted.

### Checklist
- [ ] package.sh runs without errors
- [ ] 9 tar.gz archives created
- [ ] All archives have reasonable file sizes
- [ ] Archives contain correct pack contents when extracted

---

## Scenario 9: Command Consistency Across Packs (F07, AT05)

**Goal:** Verify all 5 core packs have the same 15 commands.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. List Full pack commands:
   `ls bridge-full/.roo/commands/ | sed 's/.md$//' | sort`
2. List Claude Code pack commands:
   `ls bridge-claude-code/.claude/commands/ | sed 's/.md$//' | sort`
3. List Codex pack skills:
   `ls bridge-codex/.agents/skills/ | sort`
4. Compare -- all three lists should be identical. Run:
   ```
   diff <(ls bridge-full/.roo/commands/ | sed 's/.md$//') \
        <(ls bridge-claude-code/.claude/commands/ | sed 's/.md$//')
   ```
   - Expected: No differences.
5. Verify the 15 expected commands are present. Check for:
   bridge-advisor, bridge-brainstorm, bridge-context-create, bridge-context-update,
   bridge-design, bridge-end, bridge-eval, bridge-feature, bridge-feedback,
   bridge-gate, bridge-requirements-only, bridge-requirements, bridge-resume,
   bridge-scope, bridge-start

### Checklist
- [ ] Full pack has all 15 commands
- [ ] Claude Code pack has all 15 commands
- [ ] Codex pack has all 15 commands (as skill directories)
- [ ] Standalone pack has all 15 commands
- [ ] OpenCode pack has all 15 commands
- [ ] No extra or missing commands in any pack

---

## Scenario 10: Existing Project Support Commands (F08, AT06, UF02)

**Goal:** Verify bridge-scope and bridge-feature commands are present and contain correct prompts.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check bridge-scope exists in all packs:
   ```
   for pack in bridge-full/.roo/commands bridge-standalone/.roo/commands \
               bridge-claude-code/.claude/commands bridge-opencode/.opencode/commands; do
     [ -f "$pack/bridge-scope.md" ] && echo "OK: $pack" || echo "MISSING: $pack"
   done
   [ -d "bridge-codex/.agents/skills/bridge-scope" ] && echo "OK: codex" || echo "MISSING: codex"
   ```
   - Expected: All OK.
2. Check bridge-feature exists in all packs (same pattern).
3. Read one scope command to verify it instructs the agent to analyze existing code:
   `head -20 bridge-claude-code/.claude/commands/bridge-scope.md`
   - Expected: Instructions about analyzing existing codebase, scoping features/fixes.
4. Read one feature command:
   `head -20 bridge-claude-code/.claude/commands/bridge-feature.md`
   - Expected: Instructions about incremental requirements, appending to existing requirements.json.

### Checklist
- [ ] bridge-scope present in all 5 packs
- [ ] bridge-feature present in all 5 packs
- [ ] bridge-scope instructs analysis of existing codebase
- [ ] bridge-feature instructs incremental requirement addition

---

## Scenario 11: Post-Delivery Feedback Loop (F09, AT07-AT09, UF04)

**Goal:** Verify the feedback loop classification logic is embedded in the correct files.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Search for "ISSUES REPORTED" across all packs:
   `grep -rl 'ISSUES REPORTED' bridge-full/ bridge-standalone/ bridge-claude-code/ bridge-codex/ bridge-opencode/ | wc -l`
   - Expected: At least 10 files across orchestrator/slice-plan surfaces in the 5 packs.
2. Verify the classification rules in one pack. Read the Full pack orchestrator:
   `grep -A 5 'ISSUES REPORTED' bridge-full/.roo/rules-orchestrator/00-orchestrator.md | head -15`
   - Expected: Rules about staying in fix loop when issues are reported.
3. Verify "APPROVED" classification is paired with it:
   `grep -c 'APPROVED' bridge-full/.roo/rules-orchestrator/00-orchestrator.md`
   - Expected: At least 1 occurrence.
4. Check standalone commands embed the loop (since they have no external rules):
   `grep -c 'ISSUES REPORTED' bridge-standalone/.roo/commands/bridge-start.md`
   - Expected: At least 1 occurrence.
5. Check Codex AGENTS.md:
   `grep -c 'ISSUES REPORTED' bridge-codex/AGENTS.md`
   - Expected: At least 1 occurrence.

### Checklist
- [ ] "ISSUES REPORTED" classification present in all 5 packs
- [ ] Classification rules correctly describe fix loop behavior
- [ ] "APPROVED" classification correctly triggers advancement
- [ ] Standalone commands embed the loop inline
- [ ] Codex AGENTS.md includes feedback loop rules

---

## Scenario 12: Design Integration Command (F12)

**Goal:** Verify bridge-design exists and has meaningful content.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check bridge-design in Claude Code:
   `cat bridge-claude-code/.claude/commands/bridge-design.md | head -20`
   - Expected: Instructions about integrating a design document, PRD, or version spec.
2. Check bridge-design in Codex:
   `cat bridge-codex/.agents/skills/bridge-design/SKILL.md | head -20`
   - Expected: Similar instructions adapted for Codex format.
3. Verify bridge-design appears in all 5 packs (file exists):
   ```
   for f in bridge-full/.roo/commands/bridge-design.md \
            bridge-standalone/.roo/commands/bridge-design.md \
            bridge-claude-code/.claude/commands/bridge-design.md \
            bridge-codex/.agents/skills/bridge-design/SKILL.md \
            bridge-opencode/.opencode/commands/bridge-design.md; do
     [ -f "$f" ] && echo "OK: $f" || echo "MISSING: $f"
   done
   ```
   - Expected: All OK.

### Checklist
- [ ] bridge-design present in all 5 packs
- [ ] Contains instructions for design document integration
- [ ] Mentions PRD, version spec, or similar design inputs

---

## Scenario 13: Strategic Advisor Command (F13)

**Goal:** Verify bridge-advisor provides multi-perspective review capability.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Read the advisor command:
   `cat bridge-claude-code/.claude/commands/bridge-advisor.md`
   - Expected: Mentions 3 roles: Product Strategist, Developer Advocate, Critical Friend.
2. Check the advisor covers strategic concerns:
   `grep -i 'viability\|positioning\|launch\|roadmap\|community' bridge-claude-code/.claude/commands/bridge-advisor.md`
   - Expected: Multiple matches across these strategic topics.
3. Verify present in Codex:
   `head -20 bridge-codex/.agents/skills/bridge-advisor/SKILL.md`
   - Expected: Same 3-role structure.

### Checklist
- [ ] 3 advisor roles defined (Product Strategist, Developer Advocate, Critical Friend)
- [ ] Covers viability, positioning, launch readiness
- [ ] Present in all packs

---

## Scenario 14: Controller Pack Structure (F14, AT12, UF05)

**Goal:** Verify the controller pack contains all required files for portfolio management.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check CLAUDE.md:
   `head -5 bridge-controller/CLAUDE.md`
   - Expected: "BRIDGE Controller" header, meta-orchestrator role description.
2. Check commands (3 expected):
   `ls bridge-controller/.claude/commands/`
   - Expected: bridge-init-project.md, bridge-status.md, bridge-sync.md
3. Read bridge-status command:
   `cat bridge-controller/.claude/commands/bridge-status.md`
   - Expected: Instructions about scanning for .bridgeinclude markers, reading child project state.
4. Check controller rules:
   `head -10 bridge-controller/.claude/rules/controller.md`
   - Expected: Rules about meta-controller scope, no application code writing.
5. Check portfolio.json template:
   `cat bridge-controller/docs/portfolio.json`
   - Expected: Template structure for portfolio state.
6. Check reference guide:
   `head -10 bridge-controller/reference/controller-guide.md`
   - Expected: Guide for using the controller.
7. Verify archive was built:
   `ls -la bridge-controller.tar.gz`
   - Expected: File exists, reasonable size.

### Checklist
- [ ] CLAUDE.md present with controller role
- [ ] 3 commands present (init-project, status, sync)
- [ ] bridge-status scans for .bridgeinclude markers
- [ ] Controller rules enforce meta-only scope
- [ ] portfolio.json template present
- [ ] Reference guide present
- [ ] Archive built successfully

---

## Scenario 15: Multi-Repo Pack -- Claude Code Variant (F15, AT13, UF06)

**Goal:** Verify the multi-repo Claude Code variant has all cross-repo capabilities.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check CLAUDE.md:
   `head -5 bridge-multi-repo/claude-code/CLAUDE.md`
   - Expected: "BRIDGE Multi-Repo Workspace" header.
2. Count commands: `ls bridge-multi-repo/claude-code/.claude/commands/ | wc -l`
   - Expected: 12 commands (8 standard workflow + 4 cross-repo).
3. Verify cross-repo commands exist:
   ```
   for cmd in bridge-cross-design bridge-cross-review bridge-cross-sync bridge-repo-status; do
     [ -f "bridge-multi-repo/claude-code/.claude/commands/${cmd}.md" ] && echo "OK: $cmd" || echo "MISSING: $cmd"
   done
   ```
   - Expected: All 4 OK.
4. Read cross-design command:
   `head -15 bridge-multi-repo/claude-code/.claude/commands/bridge-cross-design.md`
   - Expected: Instructions about cross-repo API contracts, shared schemas, migration strategy.
5. Check multi-repo rules:
   `head -15 bridge-multi-repo/claude-code/.claude/rules/multi-repo.md`
   - Expected: Rules about repo access via relative paths, coordinated branches.
6. Check workspace docs templates:
   `ls bridge-multi-repo/claude-code/docs/`
   - Expected: context.json and requirements.json.
7. Check reference playbook:
   `head -5 bridge-multi-repo/claude-code/reference/multi-repo-playbook.md`
   - Expected: Multi-repo workflow guide.

### Checklist
- [ ] CLAUDE.md present with multi-repo role
- [ ] 12 commands total
- [ ] 4 cross-repo commands present (cross-design, cross-review, cross-sync, repo-status)
- [ ] Cross-design covers API contracts and migration
- [ ] Multi-repo rules enforce coordinated branches
- [ ] Workspace docs templates present
- [ ] Reference playbook present

---

## Scenario 16: Multi-Repo Pack -- Codex Variant (F15, AT13)

**Goal:** Verify the multi-repo Codex variant mirrors Claude Code capabilities.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check AGENTS.md:
   `head -5 bridge-multi-repo/codex/AGENTS.md`
   - Expected: Multi-repo workspace header.
2. Count skills: `ls bridge-multi-repo/codex/.agents/skills/ | wc -l`
   - Expected: 12 skill directories.
3. Verify cross-repo skills:
   ```
   for skill in bridge-cross-design bridge-cross-review bridge-cross-sync bridge-repo-status; do
     [ -d "bridge-multi-repo/codex/.agents/skills/${skill}" ] && echo "OK: $skill" || echo "MISSING: $skill"
   done
   ```
   - Expected: All 4 OK.
4. Verify config:
   `cat bridge-multi-repo/codex/.codex/config.toml`
   - Expected: Valid TOML configuration.
5. Check docs templates:
   `ls bridge-multi-repo/codex/docs/`
   - Expected: context.json, requirements.json.

### Checklist
- [ ] AGENTS.md present with multi-repo role
- [ ] 12 skill directories
- [ ] 4 cross-repo skills present
- [ ] .codex/config.toml present
- [ ] Docs templates present
- [ ] Skill names match Claude Code command names

---

## Scenario 17: Methodology Reference Document (F06)

**Goal:** Verify the methodology reference is comprehensive and accurate.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check file exists and has substantial content:
   `wc -l reference/BRIDGE-v2.1-methodology.md`
   - Expected: 100+ lines.
2. Verify it covers all 6 BRIDGE phases:
   `grep -i 'brainstorm\|requirements\|implementation design\|develop\|gate\|evaluate' reference/BRIDGE-v2.1-methodology.md | wc -l`
   - Expected: Multiple matches.
3. Check it documents the feedback loop:
   `grep -c 'ISSUES REPORTED' reference/BRIDGE-v2.1-methodology.md`
   - Expected: At least 1.
4. Check it documents schemas:
   `grep -i 'context.json\|requirements.json' reference/BRIDGE-v2.1-methodology.md | head -5`
   - Expected: Both schemas mentioned.

### Checklist
- [ ] Document is substantial (100+ lines)
- [ ] All 6 BRIDGE phases covered
- [ ] Feedback loop documented
- [ ] JSON schemas documented

---

## Scenario 18: Smoke Test Suite (Cross-cutting)

**Goal:** Run the automated smoke tests and verify they all pass.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Run: `./test.sh`
   - Expected: 45 smoke checks pass, 0 fail.
2. Run:
   `for f in tests/e2e/test-setup-packs.sh tests/e2e/test-pack-consistency.sh tests/e2e/test-advanced-packs.sh tests/e2e/test-workflow-content.sh; do bash "$f"; done`
   - Expected: 114 E2E assertions pass, 0 fail.
3. Review output for any warnings or skips.
   - Expected: shellcheck may be skipped if not installed. All other checks pass.

### Checklist
- [ ] test.sh exits with code 0
- [ ] 45/45 smoke checks pass
- [ ] 114/114 E2E assertions pass
- [ ] No unexpected failures or warnings

---

## Scenario 19: Greenfield Project Workflow Walkthrough (UF01)

**Goal:** Verify the full greenfield workflow makes sense by reading command prompts in sequence.

**Preconditions:** A setup project from Scenario 2 (Claude Code pack) at /tmp/bridge-eval/eval-claude/.

### Steps

1. Read brainstorm command:
   `head -30 /tmp/bridge-eval/eval-claude/.claude/commands/bridge-brainstorm.md`
   - Expected: Prompts user for an idea, structures brainstorming output.
2. Read requirements command:
   `head -30 /tmp/bridge-eval/eval-claude/.claude/commands/bridge-requirements.md`
   - Expected: Takes brainstorm output, generates structured requirements.json.
3. Read start command:
   `head -30 /tmp/bridge-eval/eval-claude/.claude/commands/bridge-start.md`
   - Expected: Plans slices from requirements, begins implementation.
4. Read gate command:
   `head -30 /tmp/bridge-eval/eval-claude/.claude/commands/bridge-gate.md`
   - Expected: Runs quality checks, produces gate report.
5. Read eval command:
   `head -30 /tmp/bridge-eval/eval-claude/.claude/commands/bridge-eval.md`
   - Expected: Generates evaluation scenarios.
6. Read feedback command:
   `head -30 /tmp/bridge-eval/eval-claude/.claude/commands/bridge-feedback.md`
   - Expected: Processes user feedback, decides iterate vs launch.
7. Verify the flow is logical: brainstorm -> requirements -> start -> gate -> eval -> feedback.

### Checklist
- [ ] brainstorm captures and structures an idea
- [ ] requirements generates structured requirements.json
- [ ] start plans and executes slices
- [ ] gate runs quality checks
- [ ] eval generates test scenarios
- [ ] feedback processes evaluation results
- [ ] Flow is coherent end-to-end

---

## Scenario 20: Session Continuity (UF03)

**Goal:** Verify resume and end commands handle session state correctly.

**Preconditions:** A setup project from Scenario 2.

### Steps

1. Read resume command:
   `cat /tmp/bridge-eval/eval-claude/.claude/commands/bridge-resume.md`
   - Expected: Reads context.json, outputs a brief about current state, identifies what to work on next.
2. Read end command:
   `cat /tmp/bridge-eval/eval-claude/.claude/commands/bridge-end.md`
   - Expected: Saves session state to context.json, writes handoff notes, lists what was done and what is next.
3. Verify resume references context.json:
   `grep 'context.json' /tmp/bridge-eval/eval-claude/.claude/commands/bridge-resume.md`
   - Expected: At least 1 reference.
4. Verify end writes to context.json:
   `grep 'context.json' /tmp/bridge-eval/eval-claude/.claude/commands/bridge-end.md`
   - Expected: At least 1 reference.

### Checklist
- [ ] Resume reads context.json and produces a session brief
- [ ] End saves state and writes handoff notes
- [ ] Both commands reference context.json
- [ ] Flow supports multi-session continuity

---

## Scenario 21: Context Management Commands (F07)

**Goal:** Verify context-create and context-update commands work correctly.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Read context-create:
   `head -20 bridge-claude-code/.claude/commands/bridge-context-create.md`
   - Expected: Instructions to scan codebase and generate initial context.json.
2. Read context-update:
   `head -20 bridge-claude-code/.claude/commands/bridge-context-update.md`
   - Expected: Instructions to sync context.json with current codebase state.
3. Verify both exist across packs:
   ```
   for pack in bridge-full/.roo/commands bridge-standalone/.roo/commands \
               bridge-claude-code/.claude/commands bridge-opencode/.opencode/commands; do
     [ -f "$pack/bridge-context-create.md" ] && [ -f "$pack/bridge-context-update.md" ] && echo "OK: $pack" || echo "MISSING: $pack"
   done
   ```
   - Expected: All OK.

### Checklist
- [ ] context-create generates initial context.json
- [ ] context-update syncs with current state
- [ ] Both present in all packs

---

## Scenario 22: Documentation Quality (F06, Cross-cutting)

**Goal:** Spot-check that platform guides and README accurately reflect the current state.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check README lists all 5 packs:
   `grep -c 'full\|standalone\|claude-code\|codex\|opencode' README.md`
   - Expected: Multiple mentions of each pack.
2. Check platform guides exist:
   `head -10 reference/platform-guides.md`
   - Expected: Guide content for multiple platforms.
3. Verify no stale command references (deleted commands should not appear):
   `grep -i 'bridge-migrate\|bridge-offload\|bridge-reintegrate' README.md reference/platform-guides.md reference/BRIDGE-v2.1-methodology.md`
   - Expected: No output (these commands were deleted).
4. Verify README lists 15 commands:
   `grep -c 'bridge-' README.md | head -1`
   - Expected: Many mentions (15+ distinct command names).

### Checklist
- [ ] README mentions all 5 packs
- [ ] Platform guides present and meaningful
- [ ] No references to deleted commands
- [ ] Command count is accurate (15)

---

## Scenario 23: End-to-End Live Test (Platform-Dependent)

**Goal:** Actually use BRIDGE with a real AI coding agent to verify the workflow works.

**Preconditions:** One of the following installed: Claude Code CLI, Codex CLI, OpenCode CLI, or RooCode extension.

### Steps (adjust for your platform)

**For Claude Code:**
1. Set up a fresh project: `./setup.sh --name "Live Test" --pack claude-code -o /tmp/bridge-live`
2. `cd /tmp/bridge-live/live-test`
3. Start Claude Code: `claude`
4. Run: `/bridge-brainstorm` and provide a simple idea (e.g., "a CLI tool that counts words in a file").
   - Expected: Agent structures the brainstorm, asks clarifying questions, produces a brainstorm summary.
5. Run: `/bridge-requirements-only` and paste a brief description.
   - Expected: Agent generates docs/requirements.json with features, acceptance tests, user flows.
6. Run: `/bridge-advisor`
   - Expected: Agent provides feedback from 3 perspectives.
7. Run: `/bridge-end`
   - Expected: Agent saves session state, produces handoff notes.

**For Codex:**
1. Set up: `./setup.sh --name "Live Test" --pack codex -o /tmp/bridge-live`
2. `cd /tmp/bridge-live/live-test`
3. Start Codex: `codex`
4. Run: `$bridge-brainstorm` with a simple idea.
5. Verify the workflow produces structured output.

### Checklist
- [ ] Agent recognizes and executes the command
- [ ] Output follows BRIDGE methodology structure
- [ ] HUMAN: block appears at the end of agent output
- [ ] docs/ files are created or updated appropriately
- [ ] Agent stays in role throughout the interaction

---

---

# BRIDGE v3 Scenarios (F16-F19)

Prerequisites for Scenarios 24-34:
- Go 1.21+ installed (`go version`)
- The BRIDGE repo cloned locally with Go source under cmd/bridge/ and internal/
- For binary tests: build first with `go build -o /tmp/bridge-bin ./cmd/bridge/`
- For TUI test (Scenario 30): a real TTY terminal

---

## Scenario 24: Go Binary Build and Help (F16, AT25)

**Goal:** Verify the bridge binary compiles, runs, and exposes all subcommands.

**Preconditions:** Terminal in the BRIDGE repo root directory. Go installed.

### Steps

1. Build the binary: `go build -o /tmp/bridge-bin ./cmd/bridge/`
   - Expected: Exits 0. Binary created at /tmp/bridge-bin.
2. Run help: `/tmp/bridge-bin --help`
   - Expected: Shows "BRIDGE v3" description and lists subcommands: new, add, orchestrator, customize, pack.
3. Check version: `/tmp/bridge-bin --version`
   - Expected: Prints a version string.
4. Verify each subcommand has help:
   ```
   for cmd in new add orchestrator customize pack; do
     /tmp/bridge-bin $cmd --help >/dev/null 2>&1 && echo "OK: $cmd" || echo "FAIL: $cmd"
   done
   ```
   - Expected: All OK.

### Checklist
- [ ] Binary compiles without errors
- [ ] --help shows all 5 subcommands (new, add, orchestrator, customize, pack)
- [ ] --version prints a version string
- [ ] Each subcommand accepts --help

---

## Scenario 25: bridge new -- Project Creation (F16, AT14, UF07)

**Goal:** Verify `bridge new` creates a project with correct structure, same as setup.sh.

**Preconditions:** Binary built at /tmp/bridge-bin.

### Steps

1. Create a project:
   `/tmp/bridge-bin new --name "V3 Test" --pack claude-code --output /tmp/bridge-v3-eval`
   - Expected: Prints setup summary. Creates /tmp/bridge-v3-eval/v3-test/.
2. Check CLAUDE.md: `head -3 /tmp/bridge-v3-eval/v3-test/CLAUDE.md`
   - Expected: Contains "V3 Test" in header.
3. Check commands: `ls /tmp/bridge-v3-eval/v3-test/.claude/commands/ | wc -l`
   - Expected: 15 command files.
4. Check agents: `ls /tmp/bridge-v3-eval/v3-test/.claude/agents/ | wc -l`
   - Expected: 5 agent files.
5. Check skills: `ls /tmp/bridge-v3-eval/v3-test/.claude/skills/ | wc -l`
   - Expected: 6 skill directories.
6. Check placeholder replacement: `grep -r '{{PROJECT_NAME}}' /tmp/bridge-v3-eval/v3-test/`
   - Expected: No output (all replaced).
7. Check docs: `ls /tmp/bridge-v3-eval/v3-test/docs/`
   - Expected: context.json, decisions.md, human-playbook.md, requirements.json.
8. Check .bridge.json: `cat /tmp/bridge-v3-eval/v3-test/.bridge.json`
   - Expected: JSON with version "3.0", pack "claude-code", personality "balanced".

### Checklist
- [ ] bridge new exits successfully
- [ ] Project directory created with correct slug
- [ ] CLAUDE.md has project name
- [ ] 15 commands, 5 agents, 6 skills present
- [ ] No unreplaced {{PROJECT_NAME}} placeholders
- [ ] docs/ templates present
- [ ] .bridge.json created with correct defaults

---

## Scenario 26: bridge new -- Codex Pack (F16, AT14)

**Goal:** Verify `bridge new` works with codex pack.

**Preconditions:** Binary built at /tmp/bridge-bin.

### Steps

1. Create: `/tmp/bridge-bin new --name "Codex V3" --pack codex --output /tmp/bridge-v3-eval`
   - Expected: Creates /tmp/bridge-v3-eval/codex-v3/.
2. Check AGENTS.md: `head -3 /tmp/bridge-v3-eval/codex-v3/AGENTS.md`
   - Expected: Contains "Codex V3".
3. Check skills: `ls /tmp/bridge-v3-eval/codex-v3/.agents/skills/ | wc -l`
   - Expected: 15 skill directories.
4. Check procedures: `ls /tmp/bridge-v3-eval/codex-v3/.agents/procedures/ | wc -l`
   - Expected: 6 procedure files.
5. Check .bridge.json: `cat /tmp/bridge-v3-eval/codex-v3/.bridge.json`
   - Expected: pack "codex".

### Checklist
- [ ] Codex project created successfully
- [ ] AGENTS.md personalized
- [ ] 15 skills, 6 procedures present
- [ ] .bridge.json tracks pack type

---

## Scenario 27: bridge new with Personality (F16, F18, AT16)

**Goal:** Verify `bridge new --personality strict` injects vibe lines into agent definitions.

**Preconditions:** Binary built at /tmp/bridge-bin.

### Steps

1. Create with strict personality:
   `/tmp/bridge-bin new --name "Strict Project" --pack claude-code --personality strict --output /tmp/bridge-v3-eval`
   - Expected: Output shows "Personality: strict".
2. Check .bridge.json personality:
   `cat /tmp/bridge-v3-eval/strict-project/.bridge.json | grep personality`
   - Expected: "personality": "strict"
3. Check vibe injection in an agent file:
   `grep -i 'vibe\|skeptical\|evidence\|rigorous' /tmp/bridge-v3-eval/strict-project/.claude/agents/bridge-architect.md`
   - Expected: Strict vibe line present (e.g., "Challenges every abstraction").
4. Check vibe in another agent:
   `grep -i 'vibe\|edge case\|shortcut\|TODO' /tmp/bridge-v3-eval/strict-project/.claude/agents/bridge-coder.md`
   - Expected: Strict coder vibe present.
5. Compare with balanced (no markers should remain empty):
   `grep -c 'BRIDGE-PERSONALITY' /tmp/bridge-v3-eval/strict-project/.claude/agents/bridge-architect.md`
   - Expected: Markers present (2 -- start and end) with vibe content between them.

### Checklist
- [ ] Personality printed in setup summary
- [ ] .bridge.json records "strict"
- [ ] Architect agent has strict vibe line
- [ ] Coder agent has strict vibe line
- [ ] Personality markers present in agent files

---

## Scenario 28: bridge new with Specializations (F16, F17, AT18, AT24)

**Goal:** Verify `bridge new --spec frontend --spec backend` copies specialization files into the project.

**Preconditions:** Binary built at /tmp/bridge-bin.

### Steps

1. Create with specs:
   `/tmp/bridge-bin new --name "Spec Project" --pack claude-code --spec frontend --spec backend --output /tmp/bridge-v3-eval`
   - Expected: Output shows "Specs: [frontend backend]".
2. Check specialization directories exist:
   ```
   ls /tmp/bridge-v3-eval/spec-project/.claude/skills/bridge-spec-frontend/SKILL.md
   ls /tmp/bridge-v3-eval/spec-project/.claude/skills/bridge-spec-backend/SKILL.md
   ```
   - Expected: Both files exist.
3. Check specialization content:
   `head -5 /tmp/bridge-v3-eval/spec-project/.claude/skills/bridge-spec-frontend/SKILL.md`
   - Expected: SKILL.md with "Frontend Specialization" or similar.
4. Check .bridge.json:
   `cat /tmp/bridge-v3-eval/spec-project/.bridge.json | grep specializations`
   - Expected: ["frontend", "backend"]
5. Verify specialization contains domain-specific content:
   `grep -i 'accessibility\|component\|responsive' /tmp/bridge-v3-eval/spec-project/.claude/skills/bridge-spec-frontend/SKILL.md`
   - Expected: Frontend-specific checklists.

### Checklist
- [ ] Specs printed in setup summary
- [ ] bridge-spec-frontend/SKILL.md exists in project skills
- [ ] bridge-spec-backend/SKILL.md exists in project skills
- [ ] Specializations contain domain-specific checklists
- [ ] .bridge.json tracks both specializations

---

## Scenario 29: bridge add -- Existing Project (F16, AT15)

**Goal:** Verify `bridge add` installs BRIDGE into an existing directory without overwriting protected content.

**Preconditions:** Binary built at /tmp/bridge-bin.

### Steps

1. Create a fake existing project:
   ```
   mkdir -p /tmp/bridge-v3-eval/existing-project/src
   echo "existing code" > /tmp/bridge-v3-eval/existing-project/src/main.go
   echo "existing readme" > /tmp/bridge-v3-eval/existing-project/README.md
   ```
2. Add BRIDGE:
   `/tmp/bridge-bin add --name "Existing" --pack claude-code --target /tmp/bridge-v3-eval/existing-project`
   - Expected: Installs BRIDGE files.
3. Verify existing files preserved:
   `cat /tmp/bridge-v3-eval/existing-project/src/main.go`
   - Expected: "existing code" (unchanged).
   `cat /tmp/bridge-v3-eval/existing-project/README.md`
   - Expected: "existing readme" (unchanged).
4. Verify BRIDGE files added:
   `ls /tmp/bridge-v3-eval/existing-project/CLAUDE.md`
   - Expected: File exists.
   `ls /tmp/bridge-v3-eval/existing-project/.claude/commands/ | wc -l`
   - Expected: 15 command files.
5. Verify .bridge.json created:
   `cat /tmp/bridge-v3-eval/existing-project/.bridge.json`
   - Expected: JSON with pack and personality fields.

### Checklist
- [ ] bridge add exits successfully
- [ ] Existing files (src/main.go, README.md) not overwritten
- [ ] CLAUDE.md and .claude/ structure added
- [ ] 15 commands present
- [ ] .bridge.json created

---

## Scenario 30: bridge Interactive TUI (F16, AT20, UF07)

**Goal:** Verify `bridge` with no args launches an interactive TUI.

**Preconditions:** Binary built at /tmp/bridge-bin. Real TTY terminal.

### Steps

1. Run with no args: `/tmp/bridge-bin`
   - Expected: An interactive menu appears with options: New project, Add to existing, Orchestrator, Customize, Pack.
2. Select "New project" (if the TUI allows).
   - Expected: A form appears asking for project name, pack, personality, specializations.
3. Press Ctrl+C or Escape to exit without completing.
   - Expected: Exits cleanly, no crash.

### Checklist
- [ ] TUI menu appears with 5 action options
- [ ] Selecting an action shows the relevant form
- [ ] Cancellation exits cleanly

---

## Scenario 31: bridge customize -- Personality Swap (F16, F18, AT17, UF08)

**Goal:** Verify `bridge customize --personality mentoring` swaps personality in an existing project.

**Preconditions:** A project from Scenario 25 at /tmp/bridge-v3-eval/v3-test/ (balanced personality).

### Steps

1. Check current personality:
   `/tmp/bridge-bin customize --list --target /tmp/bridge-v3-eval/v3-test`
   - Expected: Shows personality "balanced".
2. Swap to mentoring:
   `/tmp/bridge-bin customize --personality mentoring --target /tmp/bridge-v3-eval/v3-test`
   - Expected: Exits successfully. Prints confirmation.
3. Check .bridge.json updated:
   `cat /tmp/bridge-v3-eval/v3-test/.bridge.json | grep personality`
   - Expected: "personality": "mentoring"
4. Check vibe injection:
   `grep -i 'vibe\|mentor\|teaching\|learning\|guidance' /tmp/bridge-v3-eval/v3-test/.claude/agents/bridge-architect.md`
   - Expected: Mentoring vibe line present.
5. Verify --list reflects change:
   `/tmp/bridge-bin customize --list --target /tmp/bridge-v3-eval/v3-test`
   - Expected: Shows personality "mentoring".

### Checklist
- [ ] --list shows current personality
- [ ] Personality swap exits successfully
- [ ] .bridge.json updated to "mentoring"
- [ ] Agent files contain mentoring vibe lines
- [ ] --list reflects the new personality

---

## Scenario 32: bridge customize -- Add/Remove Specializations (F16, F17, AT18, AT19, UF08)

**Goal:** Verify adding and removing specializations via bridge customize.

**Preconditions:** A project from Scenario 25 at /tmp/bridge-v3-eval/v3-test/ (no specializations).

### Steps

1. Add specializations:
   `/tmp/bridge-bin customize --add-spec frontend --add-spec security --target /tmp/bridge-v3-eval/v3-test`
   - Expected: Exits successfully. Copies spec files.
2. Verify files:
   ```
   ls /tmp/bridge-v3-eval/v3-test/.claude/skills/bridge-spec-frontend/SKILL.md
   ls /tmp/bridge-v3-eval/v3-test/.claude/skills/bridge-spec-security/SKILL.md
   ```
   - Expected: Both exist.
3. Check .bridge.json:
   `cat /tmp/bridge-v3-eval/v3-test/.bridge.json | grep -A2 specializations`
   - Expected: ["frontend", "security"]
4. Remove one specialization:
   `/tmp/bridge-bin customize --remove-spec frontend --target /tmp/bridge-v3-eval/v3-test`
   - Expected: Exits successfully.
5. Verify removal:
   `ls /tmp/bridge-v3-eval/v3-test/.claude/skills/bridge-spec-frontend/ 2>/dev/null && echo "EXISTS" || echo "REMOVED"`
   - Expected: "REMOVED"
6. Check .bridge.json updated:
   `cat /tmp/bridge-v3-eval/v3-test/.bridge.json | grep -A2 specializations`
   - Expected: ["security"] (frontend removed).

### Checklist
- [ ] --add-spec copies SKILL.md files to project
- [ ] .bridge.json tracks added specializations
- [ ] --remove-spec removes the specialization directory
- [ ] .bridge.json updated after removal
- [ ] Remaining specialization unaffected

---

## Scenario 33: Specialization Content Quality (F17, AT24)

**Goal:** Verify all 7 specialization skill files are well-formed and contain domain-specific content.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check all 7 specialization directories exist:
   ```
   for spec in frontend backend api data infra mobile security; do
     [ -f "specializations/${spec}/SKILL.md" ] && echo "OK: $spec" || echo "MISSING: $spec"
   done
   ```
   - Expected: All 7 OK.
2. Verify SKILL.md format (frontmatter with name and description):
   ```
   for spec in frontend backend api data infra mobile security; do
     grep -q '^---' "specializations/${spec}/SKILL.md" && echo "OK: $spec has frontmatter" || echo "FAIL: $spec"
   done
   ```
   - Expected: All have YAML frontmatter.
3. Spot-check domain specificity:
   - `grep -i 'accessibility\|component\|CSS' specializations/frontend/SKILL.md | head -3`
     - Expected: Frontend-specific terms.
   - `grep -i 'endpoint\|REST\|GraphQL\|versioning' specializations/api/SKILL.md | head -3`
     - Expected: API-specific terms.
   - `grep -i 'OWASP\|authentication\|authorization\|vulnerability' specializations/security/SKILL.md | head -3`
     - Expected: Security-specific terms.
   - `grep -i 'pipeline\|ETL\|schema\|migration' specializations/data/SKILL.md | head -3`
     - Expected: Data-specific terms.
4. Verify each file has substantial content:
   ```
   for spec in frontend backend api data infra mobile security; do
     lines=$(wc -l < "specializations/${spec}/SKILL.md")
     [ "$lines" -gt 30 ] && echo "OK: $spec ($lines lines)" || echo "SHORT: $spec ($lines lines)"
   done
   ```
   - Expected: All > 30 lines.

### Checklist
- [ ] All 7 specialization directories exist with SKILL.md
- [ ] SKILL.md files have valid frontmatter (name, description)
- [ ] Frontend covers component architecture, accessibility
- [ ] API covers endpoints, versioning, REST/GraphQL
- [ ] Security covers OWASP, auth, vulnerabilities
- [ ] Data covers pipelines, schemas, ETL
- [ ] All files are substantial (30+ lines)

---

## Scenario 34: Personality Profile Quality (F18, AT23)

**Goal:** Verify all 3 personality profiles are valid JSON with 8 vibe keys.

**Preconditions:** Terminal in the BRIDGE repo root directory.

### Steps

1. Check all 3 profiles exist:
   ```
   for p in strict balanced mentoring; do
     [ -f "profiles/${p}.json" ] && echo "OK: $p" || echo "MISSING: $p"
   done
   ```
   - Expected: All 3 OK.
2. Validate JSON:
   ```
   for p in strict balanced mentoring; do
     python3 -c "import json; json.load(open('profiles/${p}.json'))" 2>/dev/null && echo "VALID: $p" || echo "INVALID: $p"
   done
   ```
   - Expected: All VALID.
3. Check 8 vibe keys in each profile:
   ```
   for p in strict balanced mentoring; do
     keys=$(python3 -c "import json; d=json.load(open('profiles/${p}.json')); print(len(d.get('vibes',{})))")
     [ "$keys" -eq 8 ] && echo "OK: $p has $keys vibes" || echo "FAIL: $p has $keys vibes"
   done
   ```
   - Expected: All have exactly 8 vibes (architect, coder, debugger, auditor, evaluator, advisor, brainstorm, orchestrator).
4. Verify vibe key names match expected roles:
   ```
   python3 -c "
   import json
   expected = {'architect','coder','debugger','auditor','evaluator','advisor','brainstorm','orchestrator'}
   for p in ['strict','balanced','mentoring']:
     d = json.load(open(f'profiles/{p}.json'))
     actual = set(d.get('vibes',{}).keys())
     if actual == expected:
       print(f'OK: {p}')
     else:
       print(f'MISMATCH: {p} — missing={expected-actual}, extra={actual-expected}')
   "
   ```
   - Expected: All OK.
5. Verify vibes are non-empty strings:
   ```
   python3 -c "
   import json
   for p in ['strict','balanced','mentoring']:
     d = json.load(open(f'profiles/{p}.json'))
     empty = [k for k,v in d.get('vibes',{}).items() if not v.strip()]
     if empty:
       print(f'EMPTY VIBES in {p}: {empty}')
     else:
       print(f'OK: {p} — all vibes are non-empty')
   "
   ```
   - Expected: All OK.

### Checklist
- [ ] All 3 profile files exist (strict, balanced, mentoring)
- [ ] All parse as valid JSON
- [ ] Each has exactly 8 vibe keys
- [ ] Vibe keys match expected role names
- [ ] All vibes are non-empty strings

---

## Scenario 35: Cross-Platform Build (F19, AT25)

**Goal:** Verify goreleaser config cross-compiles for all target platforms.

**Preconditions:** Terminal in the BRIDGE repo root directory. Go installed.

### Steps

1. Check .goreleaser.yml exists:
   `cat .goreleaser.yml | head -30`
   - Expected: Project name "bridge", builds section with goos/goarch.
2. Verify target platforms in config:
   `grep -A10 'goos:' .goreleaser.yml`
   - Expected: linux, darwin, windows.
   `grep -A5 'goarch:' .goreleaser.yml`
   - Expected: amd64, arm64.
3. Verify windows/arm64 is excluded:
   `grep -A2 'ignore:' .goreleaser.yml`
   - Expected: windows + arm64 exclusion.
4. Cross-compile manually for each target:
   ```
   for goos in linux darwin; do
     for goarch in amd64 arm64; do
       GOOS=$goos GOARCH=$goarch go build -o /dev/null ./cmd/bridge/ && echo "OK: $goos/$goarch" || echo "FAIL: $goos/$goarch"
     done
   done
   GOOS=windows GOARCH=amd64 go build -o /dev/null ./cmd/bridge/ && echo "OK: windows/amd64" || echo "FAIL: windows/amd64"
   ```
   - Expected: All 5 OK.
5. Verify archives include profiles and specializations:
   `grep -A5 'files:' .goreleaser.yml`
   - Expected: profiles/* and specializations/* listed.

### Checklist
- [ ] .goreleaser.yml exists with correct project name
- [ ] linux/amd64, linux/arm64, darwin/amd64, darwin/arm64, windows/amd64 targets defined
- [ ] windows/arm64 excluded
- [ ] All 5 cross-compile targets build successfully
- [ ] Archives configured to include profiles/ and specializations/

---

## Scenario 36: bridge new -- Error Handling (F16)

**Goal:** Verify the bridge binary handles invalid input gracefully.

**Preconditions:** Binary built at /tmp/bridge-bin.

### Steps

1. Missing required flags:
   `/tmp/bridge-bin new 2>&1; echo "exit: $?"`
   - Expected: Error about --name being required. Non-zero exit.
2. Invalid pack name:
   `/tmp/bridge-bin new --name "Test" --pack invalid-pack 2>&1; echo "exit: $?"`
   - Expected: Error about invalid pack. Non-zero exit.
3. Invalid personality:
   `/tmp/bridge-bin new --name "Test" --pack claude-code --personality aggressive 2>&1; echo "exit: $?"`
   - Expected: Error about invalid personality. Non-zero exit.
4. Directory already exists:
   `/tmp/bridge-bin new --name "V3 Test" --pack claude-code --output /tmp/bridge-v3-eval 2>&1; echo "exit: $?"`
   - Expected: Error about directory already existing. Non-zero exit.

### Checklist
- [ ] Missing --name produces clear error
- [ ] Invalid pack produces clear error with valid options
- [ ] Invalid personality produces clear error with valid options
- [ ] Existing directory produces clear error
- [ ] All error cases exit non-zero

---

## Scenario 37: .bridge.json Config Tracking (F16, F18, AT23)

**Goal:** Verify .bridge.json accurately tracks all configuration through lifecycle changes.

**Preconditions:** Binary built at /tmp/bridge-bin.

### Steps

1. Create project:
   `/tmp/bridge-bin new --name "Config Test" --pack full --personality strict --spec api --output /tmp/bridge-v3-eval`
2. Check initial state:
   `cat /tmp/bridge-v3-eval/config-test/.bridge.json`
   - Expected: version "3.0", pack "full", personality "strict", specializations ["api"].
3. Change personality:
   `/tmp/bridge-bin customize --personality mentoring --target /tmp/bridge-v3-eval/config-test`
4. Check personality updated:
   `cat /tmp/bridge-v3-eval/config-test/.bridge.json | grep personality`
   - Expected: "personality": "mentoring"
5. Add spec:
   `/tmp/bridge-bin customize --add-spec security --target /tmp/bridge-v3-eval/config-test`
6. Check specs updated:
   `cat /tmp/bridge-v3-eval/config-test/.bridge.json | grep -A3 specializations`
   - Expected: ["api", "security"]
7. Remove spec:
   `/tmp/bridge-bin customize --remove-spec api --target /tmp/bridge-v3-eval/config-test`
8. Check final state:
   `cat /tmp/bridge-v3-eval/config-test/.bridge.json`
   - Expected: version "3.0", pack "full", personality "mentoring", specializations ["security"].

### Checklist
- [ ] Initial .bridge.json has all 4 fields correct
- [ ] Personality change persists to .bridge.json
- [ ] Add-spec appends to specializations array
- [ ] Remove-spec removes from specializations array
- [ ] Pack and version unchanged through customizations

---

## Cleanup

After all scenarios are complete, clean up test artifacts:

```bash
rm -rf /tmp/bridge-eval /tmp/bridge-live /tmp/bridge-pkg-test /tmp/bridge-v3-eval /tmp/bridge-bin
```
