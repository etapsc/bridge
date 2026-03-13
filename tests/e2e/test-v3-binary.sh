#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# BRIDGE v3 -- E2E Tests: Go Binary, Specializations, Personalities, Cross-Platform
# Tests F16 (Go TUI Binary), F17 (Domain Specializations), F18 (Personality Packs), F19 (Cross-Platform)
# Tests AT14, AT15, AT16, AT17, AT18, AT19, AT23, AT24, AT25
# Maps to: UF07 (TUI-Guided New Project), UF08 (Post-Install Customization)
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRIDGE_ROOT="${SCRIPT_DIR}/../.."
TEST_DIR="/tmp/bridge-v3-e2e-$$"
BINARY="${TEST_DIR}/bridge"
PASSED=0
FAILED=0
ERRORS=()

pass() { PASSED=$((PASSED + 1)); printf "  \033[32m+\033[0m %s\n" "$1"; }
fail() { FAILED=$((FAILED + 1)); ERRORS+=("$1"); printf "  \033[31m-\033[0m %s\n" "$1"; }
section() { printf "\n\033[1m--- %s ---\033[0m\n" "$1"; }

cleanup() {
  rm -rf "${TEST_DIR}"
}
trap cleanup EXIT

mkdir -p "${TEST_DIR}"

# ============================================================
# Build the binary
# ============================================================
section "Build"

if go build -o "${BINARY}" "${BRIDGE_ROOT}/cmd/bridge/" 2>/dev/null; then
  pass "Go binary compiles successfully"
else
  fail "Go binary failed to compile"
  echo "FATAL: Cannot continue without a working binary."
  exit 1
fi

# ============================================================
# F16: Subcommands and help
# ============================================================
section "F16: CLI Subcommands"

HELP_OUTPUT=$("${BINARY}" --help 2>&1 || true)
for subcmd in new add orchestrator customize pack; do
  if echo "${HELP_OUTPUT}" | grep -q "${subcmd}"; then
    pass "Root --help lists '${subcmd}' subcommand"
  else
    fail "Root --help missing '${subcmd}' subcommand"
  fi
done

# Each subcommand accepts --help
for subcmd in new add orchestrator customize pack; do
  if "${BINARY}" "${subcmd}" --help >/dev/null 2>&1; then
    pass "${subcmd} --help exits successfully"
  else
    fail "${subcmd} --help fails"
  fi
done

# ============================================================
# AT14: bridge new -- claude-code
# ============================================================
section "AT14: bridge new --pack claude-code"

PROJECT_CC="${TEST_DIR}/projects/cc-test"
if "${BINARY}" new --name "CC Test" --pack claude-code --output "${TEST_DIR}/projects" >/dev/null 2>&1; then
  pass "bridge new --pack claude-code exits successfully"
else
  fail "bridge new --pack claude-code failed"
fi

[[ -d "${PROJECT_CC}" ]] && pass "Project directory created with correct slug" || fail "Project directory not created (expected cc-test)"

if [[ -f "${PROJECT_CC}/CLAUDE.md" ]] && grep -q 'CC Test' "${PROJECT_CC}/CLAUDE.md"; then
  pass "CLAUDE.md present with project name"
else
  fail "CLAUDE.md missing or not personalized"
fi

CMD_COUNT=$(find "${PROJECT_CC}/.claude/commands" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
[[ "${CMD_COUNT}" -eq 15 ]] && pass "15 command files present" || fail "Expected 15 commands, got ${CMD_COUNT}"

AGENT_COUNT=$(find "${PROJECT_CC}/.claude/agents" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
[[ "${AGENT_COUNT}" -eq 5 ]] && pass "5 agent files present" || fail "Expected 5 agents, got ${AGENT_COUNT}"

SKILL_COUNT=$(find "${PROJECT_CC}/.claude/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d '[:space:]')
[[ "${SKILL_COUNT}" -eq 6 ]] && pass "6 skill directories present" || fail "Expected 6 skills, got ${SKILL_COUNT}"

if grep -r '{{PROJECT_NAME}}' "${PROJECT_CC}" >/dev/null 2>&1; then
  fail "Unreplaced {{PROJECT_NAME}} placeholders found"
else
  pass "All {{PROJECT_NAME}} placeholders replaced"
fi

# docs/ templates
DOCS_MISSING=0
for doc in context.json decisions.md human-playbook.md requirements.json; do
  [[ -f "${PROJECT_CC}/docs/${doc}" ]] || DOCS_MISSING=$((DOCS_MISSING + 1))
done
[[ "${DOCS_MISSING}" -eq 0 ]] && pass "All docs/ templates present" || fail "${DOCS_MISSING} docs/ templates missing"

# AT23: .bridge.json
if [[ -f "${PROJECT_CC}/.bridge.json" ]]; then
  if python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert d.get('pack') == 'claude-code', f'pack={d.get(\"pack\")}'
assert d.get('personality') == 'balanced', f'personality={d.get(\"personality\")}'
assert 'version' in d, 'missing version'
" "${PROJECT_CC}/.bridge.json" 2>/dev/null; then
    pass ".bridge.json has correct defaults (pack=claude-code, personality=balanced)"
  else
    fail ".bridge.json has incorrect default values"
  fi
else
  fail ".bridge.json not created"
fi

# ============================================================
# AT14: bridge new -- codex
# ============================================================
section "AT14: bridge new --pack codex"

PROJECT_CX="${TEST_DIR}/projects/cx-test"
if "${BINARY}" new --name "CX Test" --pack codex --output "${TEST_DIR}/projects" >/dev/null 2>&1; then
  pass "bridge new --pack codex exits successfully"
else
  fail "bridge new --pack codex failed"
fi

if [[ -f "${PROJECT_CX}/AGENTS.md" ]] && grep -q 'CX Test' "${PROJECT_CX}/AGENTS.md"; then
  pass "Codex AGENTS.md present with project name"
else
  fail "Codex AGENTS.md missing or not personalized"
fi

CX_SKILL_COUNT=$(find "${PROJECT_CX}/.agents/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d '[:space:]')
[[ "${CX_SKILL_COUNT}" -eq 15 ]] && pass "Codex has 15 skill directories" || fail "Codex expected 15 skills, got ${CX_SKILL_COUNT}"

CX_PROC_COUNT=$(find "${PROJECT_CX}/.agents/procedures" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
[[ "${CX_PROC_COUNT}" -eq 6 ]] && pass "Codex has 6 procedure files" || fail "Codex expected 6 procedures, got ${CX_PROC_COUNT}"

# ============================================================
# AT15: bridge add -- existing project
# ============================================================
section "AT15: bridge add --pack claude-code"

EXISTING_DIR="${TEST_DIR}/projects/existing-proj"
mkdir -p "${EXISTING_DIR}/src"
echo "original code" > "${EXISTING_DIR}/src/app.js"
echo "original readme" > "${EXISTING_DIR}/README.md"

if "${BINARY}" add --name "Existing" --pack claude-code --target "${EXISTING_DIR}" >/dev/null 2>&1; then
  pass "bridge add exits successfully"
else
  fail "bridge add failed"
fi

# Existing files preserved
if grep -q 'original code' "${EXISTING_DIR}/src/app.js" 2>/dev/null; then
  pass "Existing src/app.js preserved"
else
  fail "Existing src/app.js was overwritten or deleted"
fi

if grep -q 'original readme' "${EXISTING_DIR}/README.md" 2>/dev/null; then
  pass "Existing README.md preserved"
else
  fail "Existing README.md was overwritten or deleted"
fi

# BRIDGE files added
[[ -f "${EXISTING_DIR}/CLAUDE.md" ]] && pass "CLAUDE.md added to existing project" || fail "CLAUDE.md not added"

ADD_CMD_COUNT=$(find "${EXISTING_DIR}/.claude/commands" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
[[ "${ADD_CMD_COUNT}" -eq 15 ]] && pass "15 commands added to existing project" || fail "Expected 15 commands in existing project, got ${ADD_CMD_COUNT}"

[[ -f "${EXISTING_DIR}/.bridge.json" ]] && pass ".bridge.json created in existing project" || fail ".bridge.json not created"

# ============================================================
# AT16: bridge new --personality strict
# ============================================================
section "AT16: bridge new --personality strict"

PROJECT_STRICT="${TEST_DIR}/projects/strict-test"
if "${BINARY}" new --name "Strict Test" --pack claude-code --personality strict --output "${TEST_DIR}/projects" >/dev/null 2>&1; then
  pass "bridge new --personality strict exits successfully"
else
  fail "bridge new --personality strict failed"
fi

# .bridge.json tracks personality
if [[ -f "${PROJECT_STRICT}/.bridge.json" ]] && grep -q '"strict"' "${PROJECT_STRICT}/.bridge.json"; then
  pass ".bridge.json records personality 'strict'"
else
  fail ".bridge.json does not record 'strict' personality"
fi

# Vibe injection check (strict architect should have "Challenges" or similar)
ARCHITECT_FILE="${PROJECT_STRICT}/.claude/agents/bridge-architect.md"
if [[ -f "${ARCHITECT_FILE}" ]]; then
  if grep -qi 'challenge\|skeptic\|justification\|rigorous\|evidence' "${ARCHITECT_FILE}"; then
    pass "Strict vibe injected into bridge-architect.md"
  else
    fail "Strict vibe not found in bridge-architect.md"
  fi
else
  fail "bridge-architect.md not found in strict project"
fi

# Check coder agent too
CODER_FILE="${PROJECT_STRICT}/.claude/agents/bridge-coder.md"
if [[ -f "${CODER_FILE}" ]]; then
  if grep -qi 'edge case\|shortcut\|TODO\|justify\|test' "${CODER_FILE}"; then
    pass "Strict vibe injected into bridge-coder.md"
  else
    fail "Strict vibe not found in bridge-coder.md"
  fi
else
  fail "bridge-coder.md not found in strict project"
fi

# ============================================================
# AT17: bridge customize --personality mentoring
# ============================================================
section "AT17: bridge customize --personality mentoring"

# Use the cc-test project (currently balanced)
if "${BINARY}" customize --personality mentoring --target "${PROJECT_CC}" >/dev/null 2>&1; then
  pass "bridge customize --personality mentoring exits successfully"
else
  fail "bridge customize --personality mentoring failed"
fi

if grep -q '"mentoring"' "${PROJECT_CC}/.bridge.json" 2>/dev/null; then
  pass ".bridge.json updated to 'mentoring'"
else
  fail ".bridge.json not updated to 'mentoring'"
fi

CC_ARCHITECT="${PROJECT_CC}/.claude/agents/bridge-architect.md"
if [[ -f "${CC_ARCHITECT}" ]]; then
  if grep -qi 'mentor\|teach\|learning\|explain\|guidance\|grow' "${CC_ARCHITECT}"; then
    pass "Mentoring vibe injected into bridge-architect.md"
  else
    fail "Mentoring vibe not found in bridge-architect.md after personality swap"
  fi
fi

# ============================================================
# AT18: bridge customize --add-spec
# ============================================================
section "AT18: bridge customize --add-spec"

if "${BINARY}" customize --add-spec frontend --add-spec backend --target "${PROJECT_CC}" >/dev/null 2>&1; then
  pass "bridge customize --add-spec frontend backend exits successfully"
else
  fail "bridge customize --add-spec failed"
fi

[[ -f "${PROJECT_CC}/.claude/skills/bridge-spec-frontend/SKILL.md" ]] && \
  pass "bridge-spec-frontend/SKILL.md installed" || fail "bridge-spec-frontend/SKILL.md not found"

[[ -f "${PROJECT_CC}/.claude/skills/bridge-spec-backend/SKILL.md" ]] && \
  pass "bridge-spec-backend/SKILL.md installed" || fail "bridge-spec-backend/SKILL.md not found"

if grep -q 'frontend' "${PROJECT_CC}/.bridge.json" && grep -q 'backend' "${PROJECT_CC}/.bridge.json"; then
  pass ".bridge.json tracks both specializations"
else
  fail ".bridge.json does not track both specializations"
fi

# ============================================================
# AT19: bridge customize --remove-spec
# ============================================================
section "AT19: bridge customize --remove-spec"

if "${BINARY}" customize --remove-spec frontend --target "${PROJECT_CC}" >/dev/null 2>&1; then
  pass "bridge customize --remove-spec frontend exits successfully"
else
  fail "bridge customize --remove-spec failed"
fi

if [[ -d "${PROJECT_CC}/.claude/skills/bridge-spec-frontend" ]]; then
  fail "bridge-spec-frontend directory still exists after removal"
else
  pass "bridge-spec-frontend directory removed"
fi

if grep -q 'frontend' "${PROJECT_CC}/.bridge.json" 2>/dev/null; then
  fail ".bridge.json still lists 'frontend' after removal"
else
  pass ".bridge.json no longer lists 'frontend'"
fi

# backend should still be there
if grep -q 'backend' "${PROJECT_CC}/.bridge.json" 2>/dev/null; then
  pass ".bridge.json still lists 'backend' (unaffected)"
else
  fail ".bridge.json lost 'backend' during frontend removal"
fi

# ============================================================
# AT24: Specialization SKILL.md quality
# ============================================================
section "AT24: Specialization Content Quality (F17)"

SPECS=(frontend backend api data infra mobile security)
SPEC_DIR="${BRIDGE_ROOT}/specializations"

spec_missing=0
for spec in "${SPECS[@]}"; do
  [[ -f "${SPEC_DIR}/${spec}/SKILL.md" ]] || spec_missing=$((spec_missing + 1))
done
[[ "${spec_missing}" -eq 0 ]] && pass "All 7 specialization SKILL.md files exist" || fail "${spec_missing} specialization SKILL.md files missing"

# Frontmatter check
fm_missing=0
for spec in "${SPECS[@]}"; do
  if ! head -1 "${SPEC_DIR}/${spec}/SKILL.md" | grep -q '^---'; then
    fm_missing=$((fm_missing + 1))
  fi
done
[[ "${fm_missing}" -eq 0 ]] && pass "All 7 specializations have YAML frontmatter" || fail "${fm_missing} specializations missing frontmatter"

# Content length check
short_specs=0
for spec in "${SPECS[@]}"; do
  lines=$(wc -l < "${SPEC_DIR}/${spec}/SKILL.md" | tr -d '[:space:]')
  [[ "${lines}" -gt 30 ]] || short_specs=$((short_specs + 1))
done
[[ "${short_specs}" -eq 0 ]] && pass "All 7 specializations have 30+ lines" || fail "${short_specs} specializations are too short"

# Domain specificity spot checks
if grep -qi 'accessibility\|component\|CSS\|responsive' "${SPEC_DIR}/frontend/SKILL.md"; then
  pass "Frontend spec has domain-specific terms (accessibility/component)"
else
  fail "Frontend spec missing domain-specific terms"
fi

if grep -qi 'endpoint\|REST\|GraphQL\|versioning\|API' "${SPEC_DIR}/api/SKILL.md"; then
  pass "API spec has domain-specific terms (endpoint/REST/GraphQL)"
else
  fail "API spec missing domain-specific terms"
fi

if grep -qi 'OWASP\|authentication\|authorization\|vulnerability\|injection' "${SPEC_DIR}/security/SKILL.md"; then
  pass "Security spec has domain-specific terms (OWASP/auth)"
else
  fail "Security spec missing domain-specific terms"
fi

# ============================================================
# AT23: Personality profile quality
# ============================================================
section "AT23: Personality Profile Quality (F18)"

PROFILE_DIR="${BRIDGE_ROOT}/profiles"
PROFILES=(strict balanced mentoring)

prof_missing=0
for p in "${PROFILES[@]}"; do
  [[ -f "${PROFILE_DIR}/${p}.json" ]] || prof_missing=$((prof_missing + 1))
done
[[ "${prof_missing}" -eq 0 ]] && pass "All 3 personality profiles exist" || fail "${prof_missing} profiles missing"

# JSON validity and 8 vibe keys
if python3 -c "
import json, sys
expected = {'architect','coder','debugger','auditor','evaluator','advisor','brainstorm','orchestrator'}
for p in ['strict','balanced','mentoring']:
    path = f'${PROFILE_DIR}/{p}.json'
    d = json.load(open(path))
    vibes = d.get('vibes', {})
    assert len(vibes) == 8, f'{p}: expected 8 vibes, got {len(vibes)}'
    assert set(vibes.keys()) == expected, f'{p}: key mismatch'
    for k, v in vibes.items():
        assert v.strip(), f'{p}: empty vibe for {k}'
print('all valid')
" 2>/dev/null | grep -q 'all valid'; then
  pass "All 3 profiles are valid JSON with 8 non-empty vibe keys matching expected roles"
else
  fail "Profile validation failed (JSON parse, key count, or empty vibes)"
fi

# ============================================================
# AT25: Cross-compilation
# ============================================================
section "AT25: Cross-Platform Build (F19)"

# goreleaser config
if [[ -f "${BRIDGE_ROOT}/.goreleaser.yml" ]]; then
  pass ".goreleaser.yml exists"
else
  fail ".goreleaser.yml not found"
fi

# Check targets in goreleaser
if grep -q 'linux' "${BRIDGE_ROOT}/.goreleaser.yml" && \
   grep -q 'darwin' "${BRIDGE_ROOT}/.goreleaser.yml" && \
   grep -q 'windows' "${BRIDGE_ROOT}/.goreleaser.yml"; then
  pass ".goreleaser.yml targets linux, darwin, windows"
else
  fail ".goreleaser.yml missing one or more target OS"
fi

# Verify archives include profiles and specializations
if grep -q 'profiles/\*' "${BRIDGE_ROOT}/.goreleaser.yml" && \
   grep -q 'specializations/\*' "${BRIDGE_ROOT}/.goreleaser.yml"; then
  pass ".goreleaser.yml bundles profiles/ and specializations/ in archives"
else
  fail ".goreleaser.yml does not bundle profiles/ or specializations/"
fi

# Cross-compile for all 5 targets
CROSS_TARGETS=(
  "linux:amd64"
  "linux:arm64"
  "darwin:amd64"
  "darwin:arm64"
  "windows:amd64"
)
cross_fail=0
for target in "${CROSS_TARGETS[@]}"; do
  goos="${target%%:*}"
  goarch="${target#*:}"
  if GOOS="${goos}" GOARCH="${goarch}" go build -o /dev/null "${BRIDGE_ROOT}/cmd/bridge/" 2>/dev/null; then
    pass "Cross-compile: ${goos}/${goarch}"
  else
    fail "Cross-compile failed: ${goos}/${goarch}"
    cross_fail=$((cross_fail + 1))
  fi
done

# ============================================================
# Error handling
# ============================================================
section "F16: Error Handling"

# Missing --name
if "${BINARY}" new 2>/dev/null; then
  fail "bridge new with no flags should fail"
else
  pass "bridge new with no flags exits non-zero"
fi

# Invalid pack
if "${BINARY}" new --name Test --pack invalid-pack 2>/dev/null; then
  fail "bridge new with invalid pack should fail"
else
  pass "bridge new with invalid pack exits non-zero"
fi

# Invalid personality
if "${BINARY}" new --name Test --pack claude-code --personality aggressive 2>/dev/null; then
  fail "bridge new with invalid personality should fail"
else
  pass "bridge new with invalid personality exits non-zero"
fi

# Directory already exists
if "${BINARY}" new --name "CC Test" --pack claude-code --output "${TEST_DIR}/projects" 2>/dev/null; then
  fail "bridge new into existing directory should fail"
else
  pass "bridge new into existing directory exits non-zero"
fi

# ============================================================
# .bridge.json lifecycle tracking
# ============================================================
section "AT23: .bridge.json Lifecycle"

LIFECYCLE_DIR="${TEST_DIR}/projects/lifecycle"
"${BINARY}" new --name "Lifecycle" --pack full --personality strict --spec api --output "${TEST_DIR}/projects" >/dev/null 2>&1

if [[ -f "${LIFECYCLE_DIR}/.bridge.json" ]]; then
  if python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert d['pack'] == 'full', f'pack={d[\"pack\"]}'
assert d['personality'] == 'strict', f'personality={d[\"personality\"]}'
assert 'api' in d.get('specializations', []), f'specs={d.get(\"specializations\")}'
" "${LIFECYCLE_DIR}/.bridge.json" 2>/dev/null; then
    pass "Initial .bridge.json correct (full/strict/api)"
  else
    fail "Initial .bridge.json has wrong values"
  fi
else
  fail ".bridge.json not created for lifecycle project"
fi

# Change personality
if "${BINARY}" customize --personality mentoring --target "${LIFECYCLE_DIR}" >/dev/null 2>&1; then
  if grep -q '"mentoring"' "${LIFECYCLE_DIR}/.bridge.json"; then
    pass "Personality change persists to .bridge.json"
  else
    fail "Personality change not reflected in .bridge.json"
  fi
fi

# Add spec
if "${BINARY}" customize --add-spec security --target "${LIFECYCLE_DIR}" >/dev/null 2>&1; then
  if grep -q 'security' "${LIFECYCLE_DIR}/.bridge.json"; then
    pass "Added spec persists to .bridge.json"
  else
    fail "Added spec not reflected in .bridge.json"
  fi
fi

# Remove spec
if "${BINARY}" customize --remove-spec api --target "${LIFECYCLE_DIR}" >/dev/null 2>&1; then
  if grep -q 'api' "${LIFECYCLE_DIR}/.bridge.json" 2>/dev/null; then
    fail "Removed spec 'api' still in .bridge.json"
  else
    pass "Removed spec 'api' no longer in .bridge.json"
  fi
fi

# Pack and version unchanged
if python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
assert d['pack'] == 'full', f'pack changed to {d[\"pack\"]}'
assert d.get('version', '') != '', 'version missing'
" "${LIFECYCLE_DIR}/.bridge.json" 2>/dev/null; then
  pass "Pack and version unchanged through customizations"
else
  fail "Pack or version changed during customization"
fi

# ============================================================
# Summary
# ============================================================
section "Results"
echo ""
printf "  Passed: \033[32m%d\033[0m\n" "$PASSED"
printf "  Failed: \033[31m%d\033[0m\n" "$FAILED"

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo ""
  echo "  Failures:"
  for err in "${ERRORS[@]}"; do
    printf "    \033[31m-\033[0m %s\n" "$err"
  done
fi

echo ""
exit "$FAILED"
