#!/usr/bin/env bash
# claude-setup: install Claude Code (if missing) and link personal Claude
# config into ~/.claude. Part of the base personal setup (see os/mac/setup-mac.sh).
#
# Ports the full personal config so it's functional on a fresh machine:
#   - settings.json   seeded no-clobber; Claude Code owns the live file
#   - commands/*.md   symlinked; custom slash commands
#   - skills/*        symlinked; custom skills
#
# NEVER touches secrets / runtime data:
#   ~/.claude.json (auth), history.jsonl, projects/, sessions/, caches,
#   settings.local.json, or the plugins/ tree.
#
# No plugins are installed and there is no GSD dependency: every command
# works with just git/gh and built-in tools.

set -Eeuo pipefail

println() { printf '%s\n' "$*"; }
die()     { printf '%s\n' "$*" >&2; exit 1; }

readonly _D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # claude-setup/
readonly SRC="$_D/claude-home"                                # tracked config
readonly DST="$HOME/.claude"
readonly BACKUP="$DST/.claude-setup-backup"                   # out of commands/skills

# link_into <src_glob> <dest_dir>: symlink each entry (file or dir) into
# dest_dir. Refresh existing symlinks; move existing real files/dirs into
# $BACKUP (kept out of commands/ and skills/ so they aren't loaded as
# duplicate commands/skills).
link_into() {
    local glob="$1" dest="$2"
    mkdir -p "$dest"
    local src name dst
    for src in $glob; do
        [[ -e "$src" ]] || continue
        name="$(basename "$src")"
        dst="$dest/$name"
        if [[ -L "$dst" ]]; then
            rm "$dst"
        elif [[ -e "$dst" ]]; then
            mkdir -p "$BACKUP"
            mv "$dst" "$BACKUP/$name"
            println "  backed up $name -> .claude-setup-backup/$name"
        fi
        ln -s "$src" "$dst"
        println "  linked $name"
    done
}

println "==> Claude Code setup"

##
## 1. Install Claude Code if missing.
##
if command -v claude >/dev/null 2>&1; then
    println "  Claude Code: present ($(claude --version 2>/dev/null | head -1))"
elif command -v npm >/dev/null 2>&1; then
    println "  Installing Claude Code via npm..."
    npm install -g @anthropic-ai/claude-code
else
    println "  Installing Claude Code via official installer..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

##
## 2. Seed settings.json (no-clobber). Claude Code mutates this file
##    (/config, plugin toggles), so it is a real file Claude owns -- not a
##    symlink into the repo. Edit claude-home/settings.json to change the
##    baseline for future fresh machines.
##
mkdir -p "$DST"
if [[ -e "$DST/settings.json" ]]; then
    println "  settings.json: exists, leaving Claude's live copy as-is"
else
    cp "$SRC/settings.json" "$DST/settings.json"
    println "  settings.json: seeded from repo"
fi

##
## 3. Link commands and skills (static; symlinked so edits propagate back to
##    the repo). Existing real files/dirs are backed up to *.bak.
##
println "  commands:"
link_into "$SRC/commands/*" "$DST/commands"
println "  skills:"
link_into "$SRC/skills/*" "$DST/skills"

println ""
println "Claude Code config ready (secrets + runtime data untouched)."
