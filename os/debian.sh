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

: ${XDG_CONFIG_HOME:=${HOME}/.config}      # user-specific portable configuration
: ${XDG_DATA_HOME:=${HOME}/.local/share}   # user-specific data (venvs, nvim swap)
: ${XDG_CACHE_HOME:=${HOME}/.cache}        # non-essential cached data
: ${XDG_STATE_HOME:=${HOME}/.local/state}  # persistent app state (logs, history)
export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME

TMPDIR="${TMPDIR:-/tmp}"
if [[ -z "{$XDG_RUNTIME_DIR:-}" ]]; then
  if [[ "$OSTYPE" == linux* && -d "/run/user/$(id -u)" ]]; then
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
  else
    XDG_RUNTIME_DIR="$TMPDIR/runtime-$(id -un)"
  fi
fi
export XDG_RUNTIME_DIR

# always safe to
# rm -rf ~/.cache ~/.local/state ~/.zinit

# this should go in a one-time setup
mkdir -p -m 755 $XDG_CACHE_HOME $XDG_CONFIG_HOME 
mkdir -p -m 700 $XDG_DATA_HOME $XDG_STATE_HOME

apt-get update -qq
apt-get install -y --no-install-recommends build-essential curl git vim less htop zsh stow

# change /etc/default/keyboard to swap caps for control
# XKBOPTIONS="ctrl:swapcaps"
