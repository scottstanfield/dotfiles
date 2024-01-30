#!/usr/bin/env bash
# vim:ft=sh ts=4 sw=4 et

##
## No longer used
## Use brew.sh instead
##

set -euo pipefail
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

readonly _D="$(dirname "$(readlink -f "$0")")"
cd $_D

require brew
require xcode-select

export HOMEBREW_NO_INSTALL_CLEANUP

brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font

brew install alacritty

core=(
    git  neovim openssh ripgrep rsync bash
    tmux tree   unzip   vim     zsh
)

gnu=(
    binutils coreutils diffutils findutils
    gawk     gnu-tar   gnu-which gnutls
    grep     gzip      less      make watch wdiff wget
)

extras=(
    bat
    dust      
    fd  
    glow  
    hammerspoon 
    hexyl
    htop        
    hyperfine 
    lsd 
    procs 
    scrubcsv
    shellharden 
    tokei     
    xsv
)

brew install font-meslo-lg-nerd-font
brew install "${gnu[@]}"
brew install "${extras[@]}"
brew install "${core[@]}"

softwareupdate --install-rosetta
