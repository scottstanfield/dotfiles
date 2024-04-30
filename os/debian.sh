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

[[ $EUID -eq 0 ]] || die "$0 needs to run as root. Try sudo $0"

apt update -y

packages=(
    fd-find
    git
    httpie
    jq
    neovim
    ripgrep
    wget
    zsh
)

# install core packages
apt-get install --no-install-recommends -y ${packages[*]}

# install miniconda
mkdir -p /tmp/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -u -p ~/miniconda3
rm -rf /tmp/miniconda

# install github.com/junegunn/fzf (Fuzzy Finder) from source
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install the Rust language (mostly to get the Eza replacement for ls)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
cargo install eza

exit 0
