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

1. Platform prep:
   - Debian/Ubuntu: `os/debian.sh` — `apt-get` core packages + `build-essential` + XDG env vars.
   - macOS: `os/macos-cli.sh` — ensures Xcode Command Line Tools (macOS's `build-essential` equivalent) + XDG env vars. **No Homebrew.** Optional second script `os/macos-apps.sh` installs GUI apps + fonts via brew-cask (run only if you want the full desktop setup).
2. `./install.sh` — symlinks packages and config files
3. *(optional)* `./extras.sh` — symlinks `templates/extras.toml` into `~/.config/mise/conf.d/` and runs `mise up` to install the dev/data pack. All-or-nothing; skip on minimal boxes.

**Remaining goal:** fold step 1 into step 2 so bootstrap is a single command. When editing install scripts, prefer moves that bring us closer to one-command bootstrap. Ask Scott before making it automatic.

## Link layout

`install.sh` defines two small helpers — `mylink` and `mycopy` — that replace GNU Stow for this repo. `mylink` creates one symlink per top-level entry of the package; with `--dot` it prepends `.` to the target name (so `zsh/zshrc` → `~/.zshrc`). No tree folding, no unstow mode, no recursive rename — deliberate scope limit.

| Source dir | Target | Call | Contents |
|------------|--------|------|----------|
| `config/`  | `~/.config` | `mylink config ~/.config` | `alacritty`, `bat`, `ghostty`, `git`, `lazygit`, `lima`, `nvim`, `shellcheckrc`, `tmux`, `vim` |
| `home/`    | `~` | `mylink home ~ --dot` | `zshenv` (sets `ZDOTDIR=$HOME`), `inputrc` (readline config) |
| `zsh/`     | `~` | `mylink zsh ~ --dot`  | `zshrc`, `zlogin`, `p10k.zsh` |

## Templates vs symlinks

Two files are **copied with no-clobber** via `mycopy`, not symlinked. Do not commit changes to the installed copies — they carry machine-local values.

- `templates/zshrc.local` → `~/.zshrc.local` (prompt icon, per-host color)
- `templates/gitconfig.local` → `~/.gitconfig.local` (git identity); included from `config/git/config`

Note: the tracked `templates/gitconfig.local` currently carries Scott's own identity as a default — harmless on his boxes, but keep that in mind if you're making this repo more portable for others.

## mise configuration — three-tier model

Mise tools are split across three layers by mutability:

| Layer | File | Tracked | Managed by |
|-------|------|---------|-----------|
| Experiment | `~/.config/mise/config.toml` | No — real file | `mise use -g <tool>` writes here |
| Baseline | `~/.config/mise/conf.d/baseline.toml` | Yes | `install.sh` symlinks `templates/mise-baseline.toml` |
| Extras (opt-in) | `~/.config/mise/conf.d/extras.toml` | Yes | `extras.sh` symlinks `templates/extras.toml` |

Mise merges all three at read time. Write commands (`mise use -g ...`) only touch `config.toml`, which isn't tracked — so experimenting with new tools doesn't dirty the repo. When a tool earns its keep, promote it by hand: add to `templates/mise-baseline.toml` or `templates/extras.toml`, then delete the redundant entry from `~/.config/mise/config.toml`.

**Extras are all-or-nothing.** Run `./extras.sh` on dev machines (languages, data tools, hyperfine, etc.); skip on minimal boxes. To disable after enabling: `rm ~/.config/mise/conf.d/extras.toml` (re-running `extras.sh` re-links it).

**No `config/mise/` directory.** Earlier iterations put mise config inside the stowed tree, but any `mise use -g` through the symlink leaked into the repo. Templates live outside `config/` specifically so `install.sh` and `extras.sh` can manage conf.d/ symlinks explicitly.

**OS-specific tools** use a per-entry filter rather than separate files:

```toml
lima = { version = "latest", os = ["macos"] }    # macOS only
# foo = { version = "latest", os = ["linux"] }   # Linux only
```

mise skips tools whose `os` doesn't match the host.

## XDG

The repo is mid-migration to XDG. Current branch at time of writing: `git-to-xdg`. `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, `XDG_STATE_HOME` are set early in both `zsh/zshrc` and `os/debian.sh`. Prefer XDG paths for any new config you introduce.

## Legacy files — do not edit, candidates for cleanup

These are leftovers from the pre-stow copy/link flow. `install.sh` does **not** reference them. Don't modify them to fix bugs — fix the real file under `zsh/`, `config/`, or `home/` instead.

- `install.sh` — superseded by `install.sh`
- `bashrc`, `bash_profile` — pre-XDG; zsh is the daily shell
- `init.lua` — Hammerspoon config; only `install.sh` linked it
- `ctags`
- `minimal/`, `plugins/`, `python/`, `rlang/` — present but not wired up; treat as archived until Scott reopens them

When touching this repo long-term, deleting legacy is preferred over leaving shims.

## `bin/` — known gap

`bin/` holds personal scripts (some haven't been touched since 2022–2024). The old `install.sh` did `cp bin/* ~/bin`, but `install.sh` does **not** install them. `zsh/zshrc` does put `$HOME/bin` on `PATH`, so the scripts just aren't there.

Proposed fix: add `mylink bin ~/bin` (or similar) to `install.sh` once `bin/` is tidied up. Flag this as a known improvement — don't silently patch it without discussing with Scott first.

## Testing changes to the install flow

- `./clean.sh` — removes the symlinks `install.sh` created (via the `myunlink` helper), tpm, and nvim site. Leaves `~/.zshrc.local` and `~/.gitconfig.local` alone.
- Re-run `./install.sh` after `clean.sh` to verify a fresh install still works.
- `os/ephemeral-lima.sh` spins up a throwaway Debian VM for Linux-side testing from a Mac. `lima shell deb` to get in.

## Conventions

- Shell scripts use `set -Eeuo pipefail` plus small helpers: `println`, `require`, `die`. Reference pattern: `os/boilerplate.sh` and `bash/boilerplate.sh`.
- `$HOME/.zshrc.local` and `$HOME/.zshrc.$USER` are sourced at the end of `.zshrc`. That's the escape hatch for machine-specific tweaks — don't pollute the shared `.zshrc` with per-host logic.
- `zsh/zshrc` gates `/opt/homebrew` setup behind `uname == Darwin` — follow that pattern for any new macOS-only block.
