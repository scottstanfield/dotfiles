#!/usr/bin/env bash
set -Eeuo pipefail

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

readonly _D="$(dirname "$(readlink -f "$0")")"
cd "$_D"

# Tell apt-get we can't give feedback
export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y --no-install-recommends curl git vim less htop zsh
apt-get install -y --no-install-recommends fastfetch

# change /etc/default/keyboard to swap caps for control
# XKBOPTIONS="ctrl:swapcaps"
