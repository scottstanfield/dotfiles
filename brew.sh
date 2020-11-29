#!/usr/bin/env bash
# vim:ft=sh ts=4 sw=4 et

set -euo pipefail
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

readonly _D="$(dirname "$(readlink -f "$0")")"
cd $_D

require brew

export HOMEBREW_NO_INSTALL_CLEANUP

gnu=(
    bash
    less
    make
    coreutils
    binutils
    diffutils
    findutils
    gawk
    gnu-sed
    gnu-tar
    gnu-which
    gnutls
    grep
    gzip
    watch
    wdiff
    wget
)

core=(
    git
    neovim
    openssh
    rsync
    unzip
    vim
    zsh
    tmux
    ripgrep
    tree
)

# rust programs
extras=(
    scrubcsv 
    hyperfine 
    du-dust
    xsv
    fd-find
    tokei
    lsd
    hammerspoon
    bat
    hexyl
)

neovim=(
    silicon
)

casks=(
    rectangle
    karabiner-elements
    docker
    alacritty
    miniconda
)

brew install ${gnu[*]}
brew install ${core[*]}
brew cask install ${casks[*]}
HOMEBREW_NO_AUTO_UPDATE=1 brew install ${extras[*]}

hash

exit 0
