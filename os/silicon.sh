#!/usr/bin/env bash
# vim:ft=sh ts=4 sw=4 et

set -euo pipefail
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

readonly _D="$(dirname "$(readlink -f "$0")")"
cd $_D

require brew
require xcode-select

export HOMEBREW_NO_INSTALL_CLEANUP

install_brew() {
    cd /tmp
    mkdir homebrew
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
    sudo mv homebrew /opt/homebrew
}

## tested bottles
bottles=(
    git
    zsh
    bash readline
    openssl@1.1
    node python@3.9 ruby
    autoconf automake cmake lua sqlite
    xz
    gnu-sed
    gnu-tar
)
#brew install ${bottles[*]}

universal=(
    hammerspoon
)
brew install ${universal[*]}

brew install font-meslo-lg-nerd-font

libs=(
    libev libevent libffi
    libidn libmpc libomp libpng libsodium libtasn1 libtiff libtool
    libunistring libyaml 
)
brew install ${libs[*]}

fromsource=(
   luajit
   neovim
)
brew install --build-from-source ${fromsource[*]}

gnu=(
    less
    make
    coreutils
    binutils
    diffutils
    findutils
    gawk
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

# mostly rust programs
extras=(
    scrubcsv 
    hyperfine 
    dust
    xsv
    tokei
    lsd
    hammerspoon
    bat
    hexyl
    shellharden
    htop
    procs
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

#brew install ${gnu[*]}
#brew install ${core[*]}
#brew cask install ${casks[*]}
#HOMEBREW_NO_AUTO_UPDATE=1 brew install ${extras[*]}

hash

exit 0
