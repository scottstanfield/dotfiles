#!/usr/bin/env bash
# vim:ft=sh ts=4 sw=4 et

set -euo pipefail
require() { hash "$@" || exit 127; }

_D="$(dirname "$(readlink -f "$0")")"
cd "$_D"

require brew

export HOMEBREW_NO_INSTALL_CLEANUP
export HOMEBREW_NO_AUTO_UPDATE=1

dotfiles=(
    bat
    fzf
    git
    less
    neovim
    ripgrep
    tmux
    zsh
)

dev=(
    autoconf 
    automake
    cmake
    openssl
    readline
    sqlite3
    xz
    zlib
    htop
    uv
    duckdb
)

gnu=(
    bash
    binutils
    coreutils
    diffutils
    findutils
    gawk
    gnu-sed
    gnu-tar
    gnu-which
    gnutls
    grep
    gzip
    make
    watch
    wdiff
    wget
)

extras=(
    dust
    fd
    git-delta
    hexyl
    httpstat
    hyperfine 
    jless
    jq
    miniconda
    openssh
    rsync
    silicon
    tldr
    tokei
    tree
    unzip
    vim
    xsv
)

apps=(
    ghostty
    alacritty
    hammerspoon
    handmirror
    rectangle
)

fonts=(
    font-meslo-lg-nerd-font
    font-jetbrains-mono-nerd-font
    font-monaspace-nerd-font
)

brew install ${dotfiles[*]}
brew install ${dev[*]}
brew install ${gnu[*]}
brew install ${extras[*]}
brew install ${apps[*]}
brew install ${fonts[*]}

# not sure if needed
# softwareupdate --install-rosetta

hash

exit 0
