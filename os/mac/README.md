# os/mac

macOS setup scripts. Run from a fresh clone of `~/dotfiles`.

## One command

```
os/mac/setup-mac.sh
```

`setup-mac.sh` orchestrates the whole macOS bootstrap, in order:

1. `macos-cli.sh` — Xcode Command Line Tools + XDG dirs
2. `../../install.sh` — symlink configs, bootstrap mise, install plugins
3. git / GitHub identity check (prints `user.name` / `user.email` + `gh` auth)
4. `../../claude-setup/setup.sh` — install Claude Code + link `~/.claude` config
5. `macos-defaults.sh` — **opt-in**, prompted

Steps 1–4 are idempotent and safe to re-run. Step 5 is prompted because it
mutates system state.

## Scripts

| Script | What it does | Idempotent? |
|--------|--------------|-------------|
| `setup-mac.sh` | One-command orchestrator (the flow above). Forwards its args to `install.sh`. | yes |
| `macos-cli.sh` | Ensures Xcode Command Line Tools (clang/make/git — macOS's `build-essential`) and creates the XDG base dirs. **No Homebrew.** | yes |
| `macos-apps.sh` | *Optional.* GUI apps + fonts via Homebrew Cask (ghostty, alacritty, …). Bootstraps Homebrew if missing. Run only for a full desktop setup. | yes |
| `macos-defaults.sh` | *Opt-in.* ~83 `defaults write` system preferences (Dark mode, Finder, Dock, trackpad, Caps Lock → Control on all keyboards, disabled ⌘Space, screenshots → clipboard, …). Prints a "Changes applied" summary. **Mutates system state** — `killall`s apps, installs a LaunchAgent, and wants a logout/restart. | mostly |

## Notes

- `macos-defaults.sh` is a personal snapshot. Read the "Changes applied"
  summary it prints (or the script itself) before running on a machine you
  care about — it disables ⌘Space Spotlight (assumes Raycast/Alfred) and
  remaps Caps Lock to Control system-wide.
- For Linux/Debian/Raspberry Pi bootstrap, see `../linux/`.
- Shared shell helpers live in `../boilerplate.sh`.
