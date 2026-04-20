# CLAUDE.md

Notes for future Claude sessions working in this repo. Read this before touching install scripts, shell config, or the link layout.

## What this repo is

Scott's personal dotfiles. Must work on:

- **macOS** (Apple Silicon primary, Intel supported)
- **Debian / Ubuntu** (including `os/raspbian.sh` for Raspberry Pi)
- **WSL** — best-effort, **untested**. The Debian bootstrap should mostly work. Don't add WSL-specific hacks without confirming with Scott first; he can't verify them.

Anywhere code is platform-specific, gate it with `uname` / `$OSTYPE`. Never assume `/opt/homebrew` exists on Linux.

## Canonical bootstrap

Two steps, run from a fresh clone of `~/dotfiles`:

1. `os/debian.sh` **or** `os/macos.sh` — installs system packages and exports XDG env vars.
2. `./istow.sh` — symlinks packages via the in-script `mylink` helper (GNU Stow no longer required), drops template files (no-clobber), bootstraps `mise` (installs it if missing, runs `mise trust` + `mise up`), then installs tpm and neovim plugins. Each downstream step self-skips with a re-run hint if its tool isn't on `PATH` yet.

**Remaining goal:** fold step 1 into step 2 so bootstrap is a single command. When editing install scripts, prefer moves that bring us closer to one-command bootstrap. Ask Scott before making it automatic.

## Link layout

`istow.sh` defines two small helpers — `mylink` and `mycopy` — that replace GNU Stow for this repo. `mylink` creates one symlink per top-level entry of the package; with `--dot` it prepends `.` to the target name (so `zsh/zshrc` → `~/.zshrc`). No tree folding, no unstow mode, no recursive rename — deliberate scope limit.

| Source dir | Target | Call | Contents |
|------------|--------|------|----------|
| `config/`  | `~/.config` | `mylink config ~/.config` | `nvim`, `git`, `tmux`, `mise`, `alacritty`, `ghostty`, `bat`, `lazygit`, `lima`, `vim`, `shellcheckrc` |
| `home/`    | `~` | `mylink home ~ --dot` | `zshenv` (sets `ZDOTDIR=$HOME`) |
| `zsh/`     | `~` | `mylink zsh ~ --dot`  | `zshrc`, `zlogin`, `p10k.zsh` |

## Templates vs symlinks

Two files are **copied with no-clobber** via `mycopy`, not symlinked. Do not commit changes to the installed copies — they carry machine-local values.

- `templates/zshrc.local` → `~/.zshrc.local` (prompt icon, per-host color)
- `templates/gitconfig.local` → `~/.gitconfig.local` (git identity); included from `config/git/config`

Note: the tracked `templates/gitconfig.local` currently carries Scott's own identity as a default — harmless on his boxes, but keep that in mind if you're making this repo more portable for others.

## `mise.toml` vs `mise.local.toml`

- `mise.toml` — shared tooling for every machine (checked in).
- `mise.local.toml` — **gitignored**, for per-machine tools (e.g. `lima` on macOS only).

Add cross-platform tools to `mise.toml`. Anything that only makes sense on one host goes in `mise.local.toml`.

## XDG

The repo is mid-migration to XDG. Current branch at time of writing: `git-to-xdg`. `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, `XDG_STATE_HOME` are set early in both `zsh/zshrc` and `os/debian.sh`. Prefer XDG paths for any new config you introduce.

## Legacy files — do not edit, candidates for cleanup

These are leftovers from the pre-stow copy/link flow. `istow.sh` does **not** reference them. Don't modify them to fix bugs — fix the real file under `zsh/`, `config/`, or `home/` instead.

- `install.sh` — superseded by `istow.sh`
- `bashrc`, `bash_profile`, `inputrc` — pre-XDG; zsh is the daily shell
- `init.lua` — Hammerspoon config; only `install.sh` linked it
- `ctags`
- `minimal/`, `plugins/`, `python/`, `rlang/` — present but not wired up; treat as archived until Scott reopens them

When touching this repo long-term, deleting legacy is preferred over leaving shims.

## `bin/` — known gap

`bin/` holds personal scripts (some haven't been touched since 2022–2024). The old `install.sh` did `cp bin/* ~/bin`, but `istow.sh` does **not** install them. `zsh/zshrc` does put `$HOME/bin` on `PATH`, so the scripts just aren't there.

Proposed fix: add `mylink bin ~/bin` (or similar) to `istow.sh` once `bin/` is tidied up. Flag this as a known improvement — don't silently patch it without discussing with Scott first.

## Testing changes to the install flow

- `./clean.sh` — removes the symlinks `istow.sh` created (via the `myunlink` helper), tpm, and nvim site. Leaves `~/.zshrc.local` and `~/.gitconfig.local` alone.
- Re-run `./istow.sh` after `clean.sh` to verify a fresh install still works.
- `os/ephemeral-lima.sh` spins up a throwaway Debian VM for Linux-side testing from a Mac. `lima shell deb` to get in.

## Conventions

- Shell scripts use `set -Eeuo pipefail` plus small helpers: `println`, `require`, `die`. Reference pattern: `os/boilerplate.sh` and `bash/boilerplate.sh`.
- `$HOME/.zshrc.local` and `$HOME/.zshrc.$USER` are sourced at the end of `.zshrc`. That's the escape hatch for machine-specific tweaks — don't pollute the shared `.zshrc` with per-host logic.
- `zsh/zshrc` gates `/opt/homebrew` setup behind `uname == Darwin` — follow that pattern for any new macOS-only block.
