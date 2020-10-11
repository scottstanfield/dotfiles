#!/usr/bin/env bash
# vim:ft=sh ts=4 sw=4 et

set -euo pipefail
# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }
# [[ $EUID -eq 0 ]] || die "Must run $0 as root"

# Preferred way to cd to where this script is running
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself

readonly _D="$(dirname "$(readlink -f "$0")")"
println "Location of script:" $_D
cd $_D && ls

# backup a file by appending bash
# cp filename{,.bak}

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
)

extras=(
    scrubcsv 
    hyperfine 
    du-dust
    xsv
    fd
)

casks=(
    rectangle
    karabiner-elements
    docker
)

#brew install ${gnu[*]}
#brew install ${core[*]}
HOMEBREW_NO_AUTO_UPDATE=1 brew install ${extras[*]}

hash

exit 0
