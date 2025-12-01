#!/usr/bin/env bash
set -euo pipefail

PARSERS="vim,lua,bash"

# BASH Boilerplate functions
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash -- "$@" 2>/dev/null || { echo "missing: $*" >&2; exit 127; }; }
readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"


## Pre-requisites
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.config}"

mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_CACHE_HOME

xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"

require nvim
require git 
require curl
if [[ $(uname) == "Darwin" ]]; then
    require clang
else
    require gcc
fi

rm -rf $xdg_data_home/nvim/site
curl -fLo $xdg_data_home/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim --headless +':PlugInstall --sync' +qa
nvim --headless +':TSUpdateSync vim' +qa

echo "Neovim bootstrap complete. Next launch should be clean."

