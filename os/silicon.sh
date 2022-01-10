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

languages=(
	python@3.9
	ruby
	lua
	node
	rust
)

# suggestions from pyenv for macOS 
# https://wilsonmar.github.io/pyenv/
brew install openssl readline sqlite3 xz zlib

bottles=(
    autoconf 
    automake
    cmake
    bash
    readline
    git   
    gnu-sed     
    gnu-tar
    openssl     
    xz 
    zsh
)

universal=(
    hammerspoon
    fzf
)
brew install ${universal[*]}

brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font

# minimal
# bash zsh git
# font-meslo-lg-nerd-font
# hammerspoon
# neovim 
# less wget  tmux

libs=(
    libev   libevent libffi       libidn   libmpc
    libomp  libpng   libsodium    libtasn1 libtiff
    libtool libyaml  libunistring
)
brew install ${libs[*]}

fromsource=(
   luajit
   neovim
   silicon
)

gnu=(
    binutils coreutils diffutils findutils
    gawk     gnu-tar   gnu-which gnutls
    grep     gzip      less      make watch wdiff wget
)

core=(
    git  neovim openssh ripgrep rsync
    tmux tree   unzip   vim     zsh
)

# rust programs
extras=(
    bat         dust      fd  glow  hammerspoon hexyl
    htop        hyperfine lsd procs scrubcsv
    shellharden tokei     xsv
)

cargo install silicon

casks=(
    rectangle
    karabiner-elements
    docker
    alacritty
    miniconda
)

brew install --build-from-source ${fromsource[*]}
brew install ${universal[*]}
brew install font-meslo-lg-nerd-font
brew install ${bottles[*]}
brew install ${gnu[*]}
brew install ${core[*]}
brew cask install ${casks[*]}
#HOMEBREW_NO_AUTO_UPDATE=1 brew install ${extras[*]}

pip3 install --user alacritty-colorscheme
git clone https://github.com/aaron-williamson/base16-alacritty $HOME/.config/base16

softwareupdate --install-rosetta
