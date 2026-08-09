# PR Review

**Claude: Follow this workflow. Execute phases in order. Save findings to `../reviews/PR{number}.md`.**

Comprehensive PR review with parallel subagent dispatch and interactive curation.

---

## Phase 1: Setup & Context Gathering

### Task 1.1: Select PR
- Run `gh pr list --limit 10` to show recent PRs
- User enters PR number

### Task 1.2: Fetch PR & Sync to Latest
```bash
gh pr view <pr_number> --json title,body,author,baseRefName,headRefName,files,additions,deletions
gh pr diff <pr_number>
git fetch origin <head_branch>
git merge origin/<head_branch> --ff-only  # sync to latest remote
```

### Task 1.3: Read Key Files
Read the actual source files from the diff (not just the diff hunks). For large diffs with artifact/binary/lock file deletions, skip those and focus on source code files.

### Task 1.4: Generate Change Summary
Produce:

**Core Functionality:**
- What does this PR add/change?
- Key capabilities introduced

**Files Overview:**
| File | Additions | Deletions | Status |
|------|-----------|-----------|--------|

**What's New:**
- New modules/classes/functions
- New CLI commands or flags
- New dependencies

**Breaking Changes:**
- API changes
- Removed functionality

Present summary to user before proceeding.

### Task 1.5: Initialize Review File
Create `../reviews/PR{number}.md` with Phase 1 content.

---

## Phase 2: Parallel Analysis (3 subagents)

Launch these 3 subagents in parallel. Run tests/linters directly (not via subagent) since they need shell access.

### Direct: Tests & Linters
Run directly (not in subagent):
```bash
uv run pytest tests/test_<module>/ -v --tb=short
uv run pytest tests/test_<module>/ --cov=<module> --cov-report=term-missing
uv run ruff check <changed_dirs>
uv run black --check <changed_dirs>
```

### Direct: Prior Comments
Fetch and verify prior review comments:
```bash
gh pr view <pr_number> --comments --json comments
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
```
For each actionable comment, verify if addressed in current code.

### Subagent A: Code Quality & Security
Dispatch as `general-purpose` subagent. Review all changed files for:

**Code Quality:**
- Functions > 50 lines, files > 800 lines
- Deep nesting (> 3 levels)
- Debug statements (print, breakpoint, pdb)
- TODO/FIXME comments, magic numbers/strings
- Code duplication

**Security:**
- Hardcoded credentials, API keys
- Injection risks (subprocess, path traversal)
- Unsafe deserialization, race conditions

**Architecture:**
- Circular dependencies, layer violations
- Coupling issues, pattern consistency

**Data Flow:**
- Save/load round-trip correctness
- State management, hidden global state

**Operational:**
- Unbounded loops, missing pagination
- Broad exception catching, error handling
- Logging/observability

Report findings with severity (HIGH/MEDIUM/LOW), file:line, description.

### Subagent B: Technical Deep Dive
Dispatch as `general-purpose` subagent. Investigate core implementation:

- Data persistence correctness (save/load)
- Core algorithm correctness
- Type handling (inheritance, serialization)
- Race conditions, concurrency issues
- Resource limits, unbounded growth
- Specific domain concerns (identify from PR context)

Report findings with severity, location, impact.

---

## Phase 3: Live Functional Testing

After analysis completes, locally run the new functionality introduced by the PR to surface runtime issues that unit tests and static analysis miss. This is NOT about re-running unit tests (CI handles that) — it's about exercising the actual user-facing features end-to-end.

### Task 3.1: Identify What to Test
From the Phase 1 change summary, identify:
- New CLI commands or flags added
- Changed behavior in existing commands
- New API endpoints or programmatic interfaces
- Configuration changes that affect runtime behavior

Skip: internal refactors with no user-facing change, test-only PRs, doc-only PRs.

### Task 3.2: Design Test Runs
For each new/changed capability, design a minimal live invocation that exercises it. Prefer:
- `--ephemeral` / in-memory modes to avoid polluting local state
- Small inputs that complete quickly but still exercise the code path
- Flag combinations that test the new functionality specifically

### Task 3.3: Execute Test Runs
Run each test from the worktree. For each run, capture:
- Whether it completed without crashes/tracebacks
- Whether the output is correct and well-formatted
- Any unexpected behavior, warnings, or error messages
- Approximate cost/time if relevant

### Task 3.4: Record Results
Add a live testing results table to findings:

| Test | Command | Result | Notes |
|------|---------|--------|-------|

Mark any runtime issues found as findings with appropriate severity.

---

## Phase 4: Compile Review

After all subagents complete, direct checks finish, and live testing is done:

1. Deduplicate findings across subagents
2. Cross-reference with prior review comments (mark resolved vs still-open)
3. Write consolidated `../reviews/PR{number}.md` with sections:
   - Phase 1: Change Summary
   - Phase 2: Prior Comments Status + Test/Lint Results
   - Phase 3: Live Testing Results
   - Test Coverage (table + uncovered lines)
   - Findings (grouped by HIGH/MEDIUM/LOW)
   - Summary box with counts + key recommendations

---

## Phase 5: Curation & Submission

### Task 5.1: Present Finding Summary
```
+----------------------------------------------+
| PR Review Findings Summary                   |
+----------------------------------------------+
| HIGH:     {n}                                |
| MEDIUM:   {n}                                |
| LOW:      {n}                                |
+----------------------------------------------+
```

### Task 5.2: User Curation
Ask user:
- Which findings to include?
- Any findings to exclude?
- Custom observations to add?

### Task 5.3: Check Prior Comments
Before posting, verify new findings weren't already reported:
```bash
gh pr view <pr_number> --comments --json comments
```

### Task 5.4: Submit PR Comment
Post curated findings:
```bash
gh pr comment <pr_number> --body "$(cat <<'EOF'
{formatted_findings}
EOF
)"
```

**Comment format:**
- Group by severity: HIGH, MEDIUM, LOW
- Each finding: bold title, location, concise description
- End with test/lint summary line

**Do NOT include:**
- Suggested fixes (let author decide approach)
- Emoji headers
- "These are new findings" preamble

---

## Output Artifacts

1. **Review File** - `../reviews/PR{number}.md`
2. **PR Comment(s)** - Curated findings posted to GitHub


