# claude-setup

Base personal setup for [Claude Code](https://claude.com/claude-code). Run by
`os/mac/setup-mac.sh`, or standalone:

```
claude-setup/setup.sh
```

Snapshot of the portable parts of `~/.claude`, stripped of company info,
secrets, and the GSD framework. Every command is functional with just
`git`/`gh` and Claude Code's built-in tools — no plugins or MCP required.

## What it does

1. **Installs Claude Code** if the `claude` command is missing (npm, or the
   official installer as a fallback).
2. **Seeds `~/.claude/settings.json`** from `claude-home/settings.json` —
   *no-clobber*. Claude Code mutates this file (`/config`, plugin toggles), so
   it is a real file Claude owns, not a symlink. Edit `claude-home/settings.json`
   to change the baseline for future fresh machines.
3. **Symlinks commands and skills** (`claude-home/commands/*`,
   `claude-home/skills/*`) into `~/.claude/`. Static files, so edits propagate
   back to the repo. Existing real files/dirs are backed up to `*.bak`.

## What is tracked

| Path | Contents |
|------|----------|
| `claude-home/settings.json` | Global settings: `model: opus[1m]`, `effortLevel: high`, `permissions.defaultMode: auto`. No secrets. |
| `claude-home/commands/*.md` | Slash commands: `merge`, `my-pr-review`, `pr-review-2`, `plan-exit-review`, `progress-update`, `review-doc`. |
| `claude-home/skills/*` | 17 skills: caveman, diagnose, grill-me, grill-with-docs, handoff, humanizer, improve-codebase-architecture, prototype, setup-matt-pocock-skills, tdd, tldr-update, to-issues, to-prd, triage, ubiquitous-language, write-a-skill, zoom-out. |

`review-doc` is a generic, dependency-free document reviewer (it replaced an
older MCP-specific command).

## What is deliberately NOT tracked (secret / runtime / machine-local)

`~/.claude.json` (auth), `history.jsonl`, `projects/` (transcripts),
`sessions/`, `settings.local.json` (per-machine permissions), all caches, and
the `plugins/` tree. A `.gitignore` here is a safety net against accidentally
committing any of them.

## Not included

- **Plugins / GSD** — none. Built-in Claude Code skills (`code-review`, `run`,
  `verify`, …) ship with the CLI and appear automatically.
- **MCP servers** — set up your own via `claude mcp add` if you want them.
