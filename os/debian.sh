#!/usr/bin/env bash
set -Eeuo pipefile

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"
cd "$_D"

# Tell apt-get we can't give feedback
export DEBIAN_FRONTEND=noninteractive

[[ $EUID -eq 0 ]] || die "$0 needs to run as root. Try sudo $0"


packages=(
    fd-find
    fzf
    git
    httpie
    jq
    neovim
    ripgrep
    wget
    zsh
    miniconda
)

apt-get install --no-install-recommends -y ${packages[*]}

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install eza

exit 0
