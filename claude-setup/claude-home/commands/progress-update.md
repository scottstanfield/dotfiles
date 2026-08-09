Generate a brief work progress update for $ARGUMENTS (date, e.g. "Feb 6" or "2026-02-06").

Steps:
1. Run `git log --oneline --all --author="oojas" --after="<day before date>" --before="<day after date>"` to get commits from that date
2. Run `gh pr list --state all --author="oojas" --limit 30 --json number,title,mergedAt,closedAt,createdAt` and match PRs active on that date (created, merged, or closed) to the commits. Only include PRs authored by oojas.
3. Filter out docs-only commits (commits starting with "docs:", "chore: black", pure formatting, .md-only changes)
4. Group related commits by theme/feature, then distill into 2-3 CEO-level bullets
5. Frame bullets around *what capability changed or was added* and *why it matters* — not implementation details (no function names, class names, module names, or code-level specifics)
6. Append PR number to each bullet where applicable, e.g. "(#42)"
7. Good: "Merged formal verification — specs now checked for logical contradictions before generation (#27)"
   Bad: "Fixed Z3 timeout in cross-spec gate pipeline, refactored RegenerationOrchestrator"
8. Keep each bullet to one concise line, sacrifice grammar for brevity
9. Output as a plain list ready to paste into Slack/standup
