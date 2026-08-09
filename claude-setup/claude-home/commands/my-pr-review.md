# My PR Review

**Follow this process strictly step by step**

Address feedback on your own PRs with validation and resolution workflow.

## Step 1: Select PR

List open PRs authored by current user:
```bash
gh pr list --author @me --state open --limit 10
```

Ask user which PR to review using AskUserQuestion.

## Step 2: Checkout & Fetch Context

```bash
gh pr checkout <pr_number>
gh pr view <pr_number> --json title,body,baseRefName,headRefName,files,additions,deletions
```

## Step 3: Fetch All Comments

```bash
# Review comments (line-specific)
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments

# General PR comments
gh pr view <pr_number> --comments --json comments

# Review threads
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews
```

Parse comments and filter to actionable feedback (ignore acks/thanks/approvals).

## Step 4: Create Tasks from Issues

For each actionable comment, create a task using TaskCreate with:
- **subject**: Brief description of the issue
- **description**: Full comment text, file/line location, commenter
- **activeForm**: "Addressing [brief issue]"

## Step 5: Process Each Task

For each task in order:

### 5a. Validate Issue

Read the relevant code. Then validate if issue is legitimate:

1. **Run existing tests** related to the file/function:
   ```bash
   uv run pytest tests/test_<relevant>.py -v -k "<related_test>"
   ```

2. **Check documentation examples** - if comment references docs, run the examples:
   ```bash
   # Extract and run code examples from docs
   uv run python -c "<example_code>"
   ```

3. **Create minimal reproduction** if needed:
   ```bash
   # Write quick test to verify claimed behavior
   uv run python -c "from <module> import <func>; assert <condition>"
   ```

4. **Check edge cases** mentioned in comment

### 5b. Report Validation Result

Use AskUserQuestion with findings:

**If issue is VALID:**
- Show evidence (test output, reproduction)
- Propose specific fix with code diff preview
- Options: "Accept fix" / "Modify approach" / "Skip for now"

**If issue is NOT VALID:**
- Show evidence why (passing tests, correct behavior demo)
- Explain discrepancy with commenter's concern
- Draft a reply explaining why issue is not valid
- Options: "Post reply" / "Edit reply first" / "Fix anyway" / "Skip"

If user chooses "Post reply" or after editing:
```bash
gh pr comment <pr_number> --body "Re: <issue>

<explanation with evidence>"
```

### 5c. Execute Resolution (Valid Issues Only)

Based on user choice:

**Accept fix:**
1. Make the code changes using Edit tool
2. Run tests to confirm fix doesn't break anything:
   ```bash
   uv run pytest
   ```
3. Stage and commit:
   ```bash
   git add <changed_files>
   git commit -m "<concise description of fix>"
   ```

**Skip:** Mark task complete, move on.

### 5d. Update Task Status

```
TaskUpdate: status=completed
```

## Step 6: Final Verification

After all tasks processed:

```bash
# Run full test suite
uv run pytest

# Run demo command
uv run python -m src.cli demo --intent "Design a mounting bracket for a 5kg load"

# Lint check
uv run ruff check .
uv run black --check .
```

## Step 7: Documentation Review

Check if changes are architectural/major:

1. Review all commits made during session:
   ```bash
   git log --oneline @{upstream}..HEAD
   ```

2. If changes touch:
   - Core models (`src/*/models.py`)
   - Public APIs (`src/cli.py`, `__init__.py` exports)
   - Architecture (`src/*/engine.py`, pipeline files)

   Then scan docs/ for staleness:
   ```bash
   ls docs/
   ```

3. Ask user: "Update docs?" with options per affected doc.

4. If yes, update relevant docs and commit:
   ```bash
   git add docs/
   git commit -m "docs: update for PR feedback changes"
   ```

## Step 8: Push & Summary

```bash
git push
```

Report:
- Issues addressed (count)
- Issues declined/skipped (count with reasons)
- Commits made
- Docs updated (if any)
- Link to PR
