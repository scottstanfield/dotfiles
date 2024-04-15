#!/usr/bin/env bash
set -Eeuo pipefile

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

# Preferred way to cd to where this script is running
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"
println "Location of script:" "$_D"
ls -

[[ $EUID -eq 0 ]] || die "$0 needs to run as root. Try sudo $0"


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install eza

exit 0
