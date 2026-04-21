#!/usr/bin/env bash
# Undo what istow.sh creates, for testing a fresh install.
# Leaves ~/.zshrc.local and ~/.gitconfig.local alone (machine-local).

set -Eeuo pipefail
println() { printf '%s\n' "$*"; }

cd "$(dirname "${BASH_SOURCE[0]}")"

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"

# myunlink <pkg_dir> <target_dir> [--dot]
# Remove symlinks that mylink would have created for pkg_dir in target_dir.
# Only removes symlinks that resolve back into $pkg_dir; leaves everything else.
myunlink() {
    local pkg="$1" target="$2" dot=""
    [[ "${3:-}" == "--dot" ]] && dot="."
    local abs_pkg
    abs_pkg=$(cd "$pkg" && pwd)
    for src in "$abs_pkg"/*; do
        [[ -e $src ]] || continue
        local dst="$target/${dot}$(basename "$src")"
        if [[ -L $dst ]]; then
            rm "$dst"
            println "  removed $dst"
        fi
    done
}

## Remove one stale link
[[ -L ~/.config/mise ]] && rm ~/.config/mise

println "Unlinking packages..."
myunlink config "$XDG_CONFIG_HOME"
myunlink home   "$HOME"        --dot
myunlink zsh    "$HOME"        --dot

println "Removing tmux plugins..."
rm -rf "$XDG_DATA_HOME/tmux/plugins"

println "Removing neovim plugins..."
rm -rf "$XDG_DATA_HOME/nvim/site"

println "Removing zsh plugins..."
rm -rf ~/.local/share/zinit

println "Keeping ~/.zshrc.local and ~/.gitconfig.local (machine-local files)."
println "Clean. Run ./install.sh to reinstall."
