> "This is my rifle. There are many like it, but this one is mine."

[Dotfile Creedo](https://en.wikipedia.org/wiki/Rifleman%27s_Creed)

Fork this to your github repo, then clone down to your machine:

```
cd ~
git clone https://github.com/scottstanfield/dotfiles
dotfiles/os/macos-cli.sh   # or os/debian.sh or os/raspbian.sh
dotfiles/istow.sh          # symlinks configs, bootstraps mise, installs plugins
dotfiles/extras.sh         # optional: languages + dev extras via mise
dotfiles/os/macos-apps.sh  # optional: GUI apps + fonts via brew-cask (macOS only)
```

Then if you want my changes:

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

A few rules this repo is organized around. Not dogma — they fell out of hitting the same problems more than once.

**1. Files that tools mutate can't be tracked symlinks.**
`mise use -g lnav` writes to `~/.config/mise/config.toml`. If that path is a symlink into the repo, every experiment dirties git. So the tracked mise baseline lives in `conf.d/baseline.toml` (symlinked, read-only from mise's POV), and `config.toml` stays a real untracked file mise owns. Same lesson applies to anything else that edits its own config — separate what you track (the opinionated slice) from what the tool owns (the mutable slice).

> **The broader pattern: overlay filesystems.** This is structurally identical to Linux `overlayfs` or Docker image layers — a read-only lower layer (tracked baseline), an optional read-only middle layer (tracked extras pack), and a writable upper layer (mise's own `config.toml`). Reads merge top-down with a defined precedence; writes only touch the top. The failure mode we kept hitting — tracked symlinks being modified by tools — is the overlay equivalent of accidentally routing the upperdir through the lowerdir: the isolation collapses and mutations bleed into the layer that's supposed to be read-only. Same pattern shows up in the CSS cascade, JavaScript's prototype chain, Python's MRO, ZFS/Btrfs copy-on-write, and Kubernetes kustomize overlays. Whenever you see "multiple sources merged by precedence, writes land in one designated place," it's the same shape.

**2. Machine-local data lives outside the repo.**
`~/.gitconfig.local`, `~/.zshrc.local`, `$XDG_DATA_HOME/nvim/plugged` — all outside `~/dotfiles/`. The `templates/` directory seeds them via no-clobber copies on first install. Nothing per-machine contaminates the source tree, which keeps diffs meaningful across hosts and keeps the repo portable.

**3. XDG-first, even when the tool defaults elsewhere.**
Configs go under `$XDG_CONFIG_HOME`, data under `$XDG_DATA_HOME`, cache under `$XDG_CACHE_HOME`. Tools that default to legacy paths get redirected — vim-plug writes plugins to `stdpath('data')/plugged` instead of `~/.config/nvim/plugged`. `$HOME` stays clean; every file has a principled location.

**4. Bootstrap is idempotent and silent-skip.**
`./istow.sh` can be re-run any number of times. Each downstream step (tpm, nvim plugins, mise tools) checks for its dependency on `PATH` and skips with a re-run hint if it's not there yet. No "fresh install" vs "update" modes, no destructive setup that only works once. You can interrupt and resume without tearing things down.

**5. When a dependency's surface area exceeds the need, replace it with code.**
This repo used GNU stow, but only ever the link + `--dotfiles` rename subset. That became ~15 lines of bash (`mylink` in `istow.sh`) and one fewer thing to `brew install` on a fresh mac. Same reasoning inlined the old `os/mise.sh` bootstrap into `istow.sh`. Code you control beats a dep you pin the version of.
