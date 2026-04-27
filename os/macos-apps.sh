#!/usr/bin/env bash
# Optional: GUI apps and fonts for macOS via Homebrew Cask.
# Run this only if you want the full desktop setup. CLI tooling now lives
# in mise.toml — run ./istow.sh (not this) for that.

set -Eeuo pipefail

println() { printf '%s\n' "$*"; }
die()     { printf '%s\n' "$*" >&2; exit 1; }

[[ "$(uname)" == "Darwin" ]] || die "This script is for macOS."

##
## Bootstrap Homebrew if missing (needed only for .app bundles and fonts)
##
if ! command -v brew >/dev/null 2>&1; then
    println "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_AUTO_UPDATE=1

apps=(
    ghostty
    hammerspoon
    handmirror
    rectangle
)

fonts=(
    font-meslo-lg-nerd-font
    font-jetbrains-mono-nerd-font
    font-monaspace-nerd-font
)

println "Installing GUI apps..."
brew install --cask "${apps[@]}"

println "Installing fonts..."
brew install --cask "${fonts[@]}"

# enable key repeat in VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

println ""
println "Done."
