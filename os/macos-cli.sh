#!/usr/bin/env bash
# Minimal macOS bootstrap: Xcode Command Line Tools + XDG dirs.
# Does not require or install Homebrew. Run os/macos-apps.sh separately
# for GUI apps (ghostty, alacritty, etc.) and fonts.

set -Eeuo pipefail

println() { printf '%s\n' "$*"; }
die()     { printf '%s\n' "$*" >&2; exit 1; }

readonly _D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$_D"

[[ "$(uname)" == "Darwin" ]] || die "This script is for macOS. Use os/debian.sh on Linux."

##
## Xcode Command Line Tools — provides clang, make, git, curl, basic POSIX.
## macOS equivalent of Debian's build-essential.
##
if ! xcode-select -p >/dev/null 2>&1; then
    println "Installing Xcode Command Line Tools (follow the GUI prompt)..."
    xcode-select --install || true
    println "When the install finishes, re-run this script."
    exit 0
fi
println "Xcode Command Line Tools: present"

##
## XDG base dirs (mirrors os/debian.sh)
##
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME

mkdir -p -m 755 "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME"
mkdir -p -m 700 "$XDG_DATA_HOME"  "$XDG_STATE_HOME"

println ""
println "Done. Next: ./install.sh (bootstraps mise and installs tools from mise.toml)."
