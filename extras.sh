#!/usr/bin/env bash
# Opt-in: enable the extras pack (languages, data tools, etc.) for a
# full dev setup. Skip on minimal machines. Idempotent.

set -Eeuo pipefail

println() { printf '%s\n' "$*"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

: "${XDG_CONFIG_HOME:=$HOME/.config}"
src="$DOTFILES_DIR/templates/extras.toml"
dst="$XDG_CONFIG_HOME/mise/conf.d/extras.toml"

mkdir -p "$(dirname "$dst")"
if [[ -L $dst ]]; then
    rm "$dst"
elif [[ -e $dst ]]; then
    println "!! $dst exists and is not a symlink, aborting"
    exit 1
fi
ln -s "$src" "$dst"
println "linked $dst -> $src"

if command -v mise >/dev/null 2>&1; then
    println "Running mise up..."
    mise up
else
    println "mise not found; skipping mise up. Run ./istow.sh first."
fi

println ""
println "Done. Remove $dst to disable extras."
