#!/usr/bin/env bash
# vim:filetype=sh:

## Boilerplate

set -Eeuo pipefail
shopt -s extdebug
trap cleanup SIGINT SIGTERM ERR EXIT

println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local code=$?; printf "%s\n" "$@" >&2; exit "$code"; }
msg()     { echo >&2 -e "${1-}"; }

# macOS comes with a really GNU bash version 3.2
# Minimum Bash version check > 4.2. Why? For associative array safety.
# println "${BASH_VERSINFO[*]: 0:3}"
bv=${BASH_VERSINFO[0]}${BASH_VERSINFO[0]}
((bv > 42)) || die "Need Bash version 4.2 or greater. You have $BASH_VERSION"

# Preferred way to cd to where this script is running
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
readonly _F=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"

## end of boilerplate

