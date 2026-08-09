Merge a branch into the current branch, resolving conflicts.

Usage: /merge <branch_name>

Arguments:
- $ARGUMENTS: branch name to merge from (e.g. dev, main, origin/dev)

Steps:
1. `git fetch` the target branch if it's a remote ref
2. `git merge` the target branch
3. If no conflicts, done
4. If conflicts exist:
   - Data files (`data/`): if gitignored, accept deletion (rm from tracking). Otherwise keep ours.
   - `uv.lock`: regenerate via `uv lock` after other conflicts resolved
   - All other files: show each conflict to user one by one, present both sides, ask which to keep or how to combine
5. Stage all resolved files
6. Commit with message: `merge: <branch> into <current_branch>`
7. Ask user if they want to push
