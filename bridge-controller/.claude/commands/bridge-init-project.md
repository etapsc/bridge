---
description: "Initialize or update BRIDGE configuration in a child project"
---

Scaffold BRIDGE into a child project folder. The user will specify:
- **Target path**: which subfolder to initialize
- **Platform**: claude-code (default), codex, opencode, roocode-full, roocode-standalone
- **Project name**: for {{PROJECT_NAME}} replacement

Steps:

1. Verify the target path exists. If not, ask whether to create it.
2. Check if the target folder already has a `.bridgeinclude` marker. If not, create one:
   ```toml
   type = "project"
   description = ""
   platform = "<chosen-platform>"
   ```
   Ask the user to fill in the description.
3. Create the appropriate BRIDGE configuration for the chosen platform:
   - **claude-code**: CLAUDE.md, .claude/commands/, .claude/skills/, .claude/rules/, docs/
   - **codex**: AGENTS.md, .agents/skills/, .agents/procedures/, .codex/config.toml, docs/
   - **opencode**: AGENTS.md, .opencode/commands/, .opencode/skills/, docs/
   - **roocode-full**: .roo/.roomodes, .roo/rules/, .roo/skills/, .roo/commands/, docs/
   - **roocode-standalone**: .roo/commands/ (self-contained), docs/
4. Create `docs/requirements.json` and `docs/context.json` templates with the project name filled in.

Report what was created and what the user should do next (typically: run `/bridge-brainstorm` or `/bridge-scope` in the child project).
