#!/usr/bin/env bash
# Optional: GUI apps and fonts for macOS via Homebrew Cask.
# Run this only if you want the full desktop setup. CLI tooling now lives
# in mise.toml — run install.sh (not this) for that.

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

# Install a cask if not already installed.
# Skips if the cask is recorded by brew OR if its .app already exists in /Applications.
install_cask() {
    local cask="$1"
    if brew list --cask --versions "$cask" >/dev/null 2>&1; then
        println "  ✓ $cask already installed (brew)"
        return 0
    fi
    println "  → installing $cask"
    if ! brew install --cask "$cask"; then
        # Most common failure: app exists in /Applications but wasn't brew-installed.
        # Adopt it instead of failing.
        println "    retrying with --adopt..."
        brew install --cask --adopt "$cask" || {
            println "  ✗ failed to install $cask (continuing)"
            return 1
        }
    fi
}

# Print the subset of the given casks that brew doesn't already have installed.
missing_casks() {
    local cask
    for cask in "$@"; do
        brew list --cask --versions "$cask" >/dev/null 2>&1 || printf '%s\n' "$cask"
    done
}

apps=(
    ghostty
    hammerspoon
    rectangle
)

# enable key repeat in VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# tell Hammerspoon where to find it's config
mkdir -p $XDG_CONFIG_HOME/hammerspoon
defaults write org.hammerspoon.Hammerspoon MJConfigFile $XDG_CONFIG_HOME/hammerspoon/init.lua


# I like handmirror but you'll need to get it from the app store
# handmirror

fonts=(
    font-meslo-lg-nerd-font
    font-jetbrains-mono-nerd-font
    font-monaspace-nerd-font
    font-sf-mono-nerd-font-ligaturized
)

println "Installing GUI apps..."
mapfile -t apps_missing < <(missing_casks "${apps[@]}")
if (( ${#apps_missing[@]} > 0 )); then
    brew install --cask --adopt "${apps_missing[@]}"
else
    println "  all apps already installed"
fi

println "Installing fonts..."
mapfile -t fonts_missing < <(missing_casks "${fonts[@]}")
if (( ${#fonts_missing[@]} > 0 )); then
    brew install --cask --quiet "${fonts_missing[@]}"
else
    println "  all fonts already installed"
fi

# tell Hammerspoon where to find it's config
mkdir -p $XDG_CONFIG_HOME/hammerspoon
defaults write org.hammerspoon.Hammerspoon MJConfigFile $XDG_CONFIG_HOME/hammerspoon/init.lua

println ""
println "Done."
