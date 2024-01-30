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

dev=(
    openssl
    readline
    sqlite3
    xz
    zlib
    autoconf 
    automake
    cmake
    nvim
    jq
    fzf
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
    less
    make
    watch
    wdiff
    wget
)

core=(
    fd-find
    fzf
    git
    git-delta
    neovim
    openssh
    ripgrep
    rsync
    tmux
    tree
    unzip
    vim
    zsh
)

# rust programs
extras=(
    bat
    du-dust
    hexyl
    hyperfine 
    scrubcsv 
    silicon
    tokei
    xsv
    jless
)

casks=(
    rectangle
    hammerspoon
    alacritty
    vanilla
)

# Install Hand Mirror from here
# https://handmirror.app/

brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font

brew install ${dev[*]}
brew install ${gnu[*]}
brew install ${core[*]}
brew cask install ${casks[*]}
HOMEBREW_NO_AUTO_UPDATE=1 brew install ${extras[*]}

npx alacritty-themes Dracula

# might need to rel
# pip3 install --user alacritty-colorscheme
# git clone https://github.com/aaron-williamson/base16-alacritty $HOME/.config/base16

softwareupdate --install-rosetta

hash

exit 0
