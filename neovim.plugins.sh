#!/usr/bin/env bash
set -euo pipefail

PARSERS="vim,lua,bash"

# BASH Boilerplate functions
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash -- "$@" 2>/dev/null || { echo "missing: $*" >&2; exit 127; }; }
readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"


## Pre-requisites
: "${XDG_DATA_HOME:-missing}"
: "${XDG_CACHE_HOME:-missing}"
require nvim
require git 
require curl
if [[ $(uname) == "Darwin" ]]; then
    require clang
else
    require gcc
fi

rm -rf $XDG_DATA_HOME/nvim/site
curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim --headless +':PlugInstall --sync' +qa
nvim --headless +':TSUpdateSync vim' +qa

echo "Neovim bootstrap complete. Next launch should be clean."

