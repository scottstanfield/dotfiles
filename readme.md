> "This is my rifle. There are many like it, but this one is mine."

[Dotfile Creedo](https://en.wikipedia.org/wiki/Rifleman%27s_Creed)

## Fork this to your github repo, then clone down to your machine:

```
cd ~
git clone https://github.com/scottstanfield/dotfiles

# if Debian:
sudo dotfiles/os/debian.sh

# or Mac CLI?
dotfiles/os/macos-cli.sh   # or sudo os/debian.sh or os/raspbian.sh

dotfiles/install.sh        # symlinks configs, bootstraps mise, installs plugins
zsh
chsh -s $(which zsh)


dotfiles/extras.sh         # optional: languages + dev extras via mise
dotfiles/os/macos-apps.sh  # optional: GUI apps + fonts via brew-cask (macOS only)
```

## Then if you want my changes:

```
git fetch upstream && git merge upstream/main && git push
```

## iCloud Drive link

Apple moved iCloud to a spot that's really hard to find, if you're on
the command line: `~/Library/Mobile Documents/com~apple~CloudDocs`. I
like to make a soft link to my home root so it's easier to get to:

```
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" $HOME/iCloud
```

## Principles

I've been working on this repo for years and recently tried refactoring the setup with
Claude. So far, so good. I did this during a big shift to `mise` my new favorite tool for
isolating dependencies. I'm keeping the claude notes around as a hint to what happened.

**1. Files that tools mutate can't be tracked symlinks.**
`mise use -g lnav` writes to `~/.config/mise/config.toml`. If that path is a symlink into the repo, every experiment dirties git. So the tracked mise baseline lives in `conf.d/baseline.toml` (symlinked, read-only from mise's POV), and `config.toml` stays a real untracked file mise owns. Same lesson applies to anything else that edits its own config — separate what you track (the opinionated slice) from what the tool owns (the mutable slice).

> **The broader pattern: overlay filesystems.** This is structurally identical to Linux `overlayfs` or Docker image layers — a read-only lower layer (tracked baseline), an optional read-only middle layer (tracked extras pack), and a writable upper layer (mise's own `config.toml`). Reads merge top-down with a defined precedence; writes only touch the top. The failure mode we kept hitting — tracked symlinks being modified by tools — is the overlay equivalent of accidentally routing the upperdir through the lowerdir: the isolation collapses and mutations bleed into the layer that's supposed to be read-only. Same pattern shows up in the CSS cascade, JavaScript's prototype chain, Python's MRO, ZFS/Btrfs copy-on-write, and Kubernetes kustomize overlays. Whenever you see "multiple sources merged by precedence, writes land in one designated place," it's the same shape.

**2. Machine-local data lives outside the repo.**
`~/.gitconfig.local`, `~/.zshrc.local`, `$XDG_DATA_HOME/nvim/plugged` — all outside `~/dotfiles/`. The `templates/` directory seeds them via no-clobber copies on first install. Nothing per-machine contaminates the source tree, which keeps diffs meaningful across hosts and keeps the repo portable.

**3. XDG-first, even when the tool defaults elsewhere.**
Configs go under `$XDG_CONFIG_HOME`, data under `$XDG_DATA_HOME`, cache under `$XDG_CACHE_HOME`. Tools that default to legacy paths get redirected — vim-plug writes plugins to `stdpath('data')/plugged` instead of `~/.config/nvim/plugged`. `$HOME` stays clean; every file has a principled location.

**4. Bootstrap is idempotent and silent-skip.**
`./install.sh` can be re-run any number of times. Each downstream step (tpm, nvim plugins, mise tools) checks for its dependency on `PATH` and skips with a re-run hint if it's not there yet. No "fresh install" vs "update" modes, no destructive setup that only works once. You can interrupt and resume without tearing things down.

**5. When a dependency's surface area exceeds the need, replace it with code.**
This repo used GNU stow, but only ever the link + `--dotfiles` rename subset. That became ~15 lines of bash (`mylink` in `istow.sh`) and one fewer thing to `brew install` on a fresh mac. Same reasoning inlined the old `os/mise.sh` bootstrap into `istow.sh`. Code you control beats a dep you pin the version of.


# CLAUDE.md

Notes for future Claude sessions working in this repo. Read this before touching install
scripts, shell config, or the link layout.

## What this repo is

Scott's personal dotfiles. Must work on:

- **macOS** (Apple Silicon primary, Intel supported)
- **Debian / Ubuntu** (including `os/raspbian.sh` for Raspberry Pi)
- **WSL** — best-effort, **untested**. The Debian bootstrap should mostly work. Don't add
  WSL-specific hacks without confirming with Scott first; he can't verify them.

Anywhere code is platform-specific, gate it with `uname` / `$OSTYPE`. Never assume
`/opt/homebrew` exists on Linux.

## Canonical bootstrap

Two steps, run from a fresh clone of `~/dotfiles`:

1. Platform prep:
   - Debian/Ubuntu: `os/debian.sh` — `apt-get` core packages + `build-essential` + XDG env
     vars.
   - macOS: `os/macos-cli.sh` — ensures Xcode Command Line Tools (macOS's
     `build-essential` equivalent) + XDG env vars. **No Homebrew.** Optional second script
     `os/macos-apps.sh` installs GUI apps + fonts via brew-cask (run only if you want the
     full desktop setup).
2. `./install.sh` — symlinks packages and config files
3. *(optional)* `./extras.sh` — symlinks `templates/extras.toml` into
`~/.config/mise/conf.d/` and runs `mise up` to install the dev/data pack. All-or-nothing;
skip on minimal boxes.

**Remaining goal:** fold step 1 into step 2 so bootstrap is a single command. When editing
install scripts, prefer moves that bring us closer to one-command bootstrap. Ask Scott
before making it automatic.

## Link layout

`install.sh` defines two small helpers — `mylink` and `mycopy` — that replace GNU Stow for
this repo. `mylink` creates one symlink per top-level entry of the package; with `--dot`
it prepends `.` to the target name (so `zsh/zshrc` → `~/.zshrc`). No tree folding, no
unstow mode, no recursive rename — deliberate scope limit.

| Source dir | Target | Call | Contents | |------------|--------|------|----------| |
`config/`  | `~/.config` | `mylink config ~/.config` | `alacritty`, `bat`, `ghostty`,
`git`, `lazygit`, `lima`, `nvim`, `shellcheckrc`, `tmux`, `vim` | | `home/`    | `~` |
`mylink home ~ --dot` | `zshenv` (sets `ZDOTDIR=$HOME`), `inputrc` (readline config) | |
`zsh/`     | `~` | `mylink zsh ~ --dot`  | `zshrc`, `zlogin`, `p10k.zsh` |

## Templates vs symlinks

Two files are **copied with no-clobber** via `mycopy`, not symlinked. Do not commit
changes to the installed copies — they carry machine-local values.

- `templates/zshrc.local` → `~/.zshrc.local` (prompt icon, per-host color)
- `templates/gitconfig.local` → `~/.gitconfig.local` (git identity); included from
  `config/git/config`

Note: the tracked `templates/gitconfig.local` currently carries Scott's own identity as a
default — harmless on his boxes, but keep that in mind if you're making this repo more
portable for others.

## mise configuration — three-tier model

Mise tools are split across three layers by mutability:

| Layer | File | Tracked | Managed by | |-------|------|---------|-----------| |
Experiment | `~/.config/mise/config.toml` | No — real file | `mise use -g <tool>` writes
here | | Baseline | `~/.config/mise/conf.d/baseline.toml` | Yes | `install.sh` symlinks
`templates/mise-baseline.toml` | | Extras (opt-in) | `~/.config/mise/conf.d/extras.toml` |
Yes | `extras.sh` symlinks `templates/extras.toml` |

Mise merges all three at read time. Write commands (`mise use -g ...`) only touch
`config.toml`, which isn't tracked — so experimenting with new tools doesn't dirty the
repo. When a tool earns its keep, promote it by hand: add to
`templates/mise-baseline.toml` or `templates/extras.toml`, then delete the redundant entry
from `~/.config/mise/config.toml`.

**Extras are all-or-nothing.** Run `./extras.sh` on dev machines (languages, data tools,
hyperfine, etc.); skip on minimal boxes. To disable after enabling: `rm
~/.config/mise/conf.d/extras.toml` (re-running `extras.sh` re-links it).

**No `config/mise/` directory.** Earlier iterations put mise config inside the stowed
tree, but any `mise use -g` through the symlink leaked into the repo. Templates live
outside `config/` specifically so `install.sh` and `extras.sh` can manage conf.d/ symlinks
explicitly.

**OS-specific tools** use a per-entry filter rather than separate files:

```toml lima = { version = "latest", os = ["macos"] }    # macOS only # foo = { version =
"latest", os = ["linux"] }   # Linux only ```

mise skips tools whose `os` doesn't match the host.

## XDG

The repo is mid-migration to XDG. Current branch at time of writing: `git-to-xdg`.
`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, `XDG_STATE_HOME` are set early in
both `zsh/zshrc` and `os/debian.sh`. Prefer XDG paths for any new config you introduce.

## Legacy files — do not edit, candidates for cleanup

These are leftovers from the pre-stow copy/link flow. `install.sh` does **not** reference
them. Don't modify them to fix bugs — fix the real file under `zsh/`, `config/`, or
`home/` instead.

- `install.sh` — superseded by `install.sh`
- `bashrc`, `bash_profile` — pre-XDG; zsh is the daily shell
- `init.lua` — Hammerspoon config; only `install.sh` linked it
- `ctags`
- `minimal/`, `plugins/`, `python/`, `rlang/` — present but not wired up; treat as
  archived until Scott reopens them

When touching this repo long-term, deleting legacy is preferred over leaving shims.

## `bin/` — known gap

`bin/` holds personal scripts (some haven't been touched since 2022–2024). The old
`install.sh` did `cp bin/* ~/bin`, but `install.sh` does **not** install them. `zsh/zshrc`
does put `$HOME/bin` on `PATH`, so the scripts just aren't there.

Proposed fix: add `mylink bin ~/bin` (or similar) to `install.sh` once `bin/` is tidied
up. Flag this as a known improvement — don't silently patch it without discussing with
Scott first.

## Testing changes to the install flow

- `./clean.sh` — removes the symlinks `install.sh` created (via the `myunlink` helper),
  tpm, and nvim site. Leaves `~/.zshrc.local` and `~/.gitconfig.local` alone.
- Re-run `./install.sh` after `clean.sh` to verify a fresh install still works.
- `os/ephemeral-lima.sh` spins up a throwaway Debian VM for Linux-side testing from a Mac.
  `lima shell deb` to get in.

## Conventions

- Shell scripts use `set -Eeuo pipefail` plus small helpers: `println`, `require`, `die`.
  Reference pattern: `os/boilerplate.sh` and `bash/boilerplate.sh`.
- `$HOME/.zshrc.local` and `$HOME/.zshrc.$USER` are sourced at the end of `.zshrc`. That's
  the escape hatch for machine-specific tweaks — don't pollute the shared `.zshrc` with
  per-host logic.
- `zsh/zshrc` gates `/opt/homebrew` setup behind `uname == Darwin` — follow that pattern
  for any new macOS-only block.
