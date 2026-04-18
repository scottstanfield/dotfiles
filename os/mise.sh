#!/usr/bin/env bash

# this is meant to be sourced like this:
# . mise.sh
#
set -Eeuo pipefail

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "${ret:-1}"; }

readonly _D="$(dirname "$(readlink -f "$0")")"
cd "$_D"

if ! command -v mise &>/dev/null; then
    bash <(curl --fail --silent --show-error --location https://mise.run)
    export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

fi

if ! grep -q 'mise/shims' "$HOME/.bashrc"; then
    cat >> $HOME/.bashrc <<EOF
# mise
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
EOF
fi

mise use --global neovim eza fd ripgrep fzf
