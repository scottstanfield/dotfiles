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

curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
eval $"(mise activate bash)"

require mise

mise use --global nvim uv eza jq wget zsh


# change /etc/default/keyboard to swap caps for control
# XKBOPTIONS="ctrl:swapcaps"

exit 0
