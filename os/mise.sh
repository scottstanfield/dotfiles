#!/usr/bin/env bash
set -Eeuo pipefail

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

readonly _D="$(dirname "$(readlink -f "$0")")"
cd "$_D"

if ! command -v mise &>/dev/null; then
    bash <(curl --fail --silent --show-error --location https://mise.run)
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(mise activate bash)"
fi

mise use --global neovim uv eza bat duf fd jq ripgrep zoxide delta fzf
