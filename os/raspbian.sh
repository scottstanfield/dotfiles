#!/usr/bin/env bash
set -Eeuo pipefile

die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

# Preferred way to cd to where this script is running
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"

sudo apt-install -y neovim zsh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
