#!/usr/bin/env bash
set -Eeuo pipefail

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"
cd "$_D"

# Tell apt-get we can't give feedback
export DEBIAN_FRONTEND=noninteractive

# install webi which is used to install some simple programs
curl https://webi.sh/webi | sh
webi rust go fd ripgrep fzf zoxide bat

# [[ $EUID -eq 0 ]] || die "$0 needs to run as root. Try sudo $0"

packages=(
    git
    httpie
    jq
    neovim
    wget
    zsh
)

# install core packages
sudo apt-get install --no-install-recommends -y ${packages[*]}

# install miniconda
mkdir -p /tmp/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -u -p ~/miniconda3
rm -rf /tmp/miniconda

# install the Rust language (mostly to get the Eza replacement for ls)
cargo install eza

# change /etc/default/keyboard to swap caps for control
# XKBOPTIONS="ctrl:swapcaps"

exit 0
