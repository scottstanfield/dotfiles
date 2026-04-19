#!/usr/bin/env bash
# Undo everything istow.sh creates, for testing a fresh install.

set -euo pipefail
println() { printf '%s\n' "$*"; }

cd "$(dirname "${BASH_SOURCE[0]}")"

println "Unstowing packages..."
stow -D -t ~/.config config 2>/dev/null || true
stow -D -t ~ home 2>/dev/null || true
stow -D -t ~ zsh 2>/dev/null || true

println "Removing tmux plugins..."
rm -rf ~/.local/share/tmux/plugins

println "Removing neovim plugins..."
rm -rf ~/.local/share/nvim/site

println "Keeping ~/.zshrc.local and ~/.config/git/local (user-specific files)."

println "Clean. Run ./istow.sh to reinstall."
