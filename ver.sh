#!/usr/bin/env bash
# vim:filetype=sh:

# Bash "strict mode": http://redsymbol.net/articles/unofficial-bash-strict-mode/

require() { hash "$@" || exit 127; }
println() { printf '%s\n' "$*"; }
die()     { ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

# Minimum Bash version check > 4.2. Why? For associative array safety.
# println "${BASH_VERSINFO[*]: 0:3}"
bv=${BASH_VERSINFO[0]}${BASH_VERSINFO[0]}
((bv > 42)) || die "Need Bash version 4.2 or greater. You have $BASH_VERSION"

# https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md
set -o errexit  # Exit on error. Append "|| true" if you expect an error.
set -o errtrace # Exit on error inside any functions or subshells.
set -o nounset  # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o pipefail # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
shopt -s nullglob globstar

__dir="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
println "$__dir"
ls

# backup a file by appending bash
# cp filename{,.bak}

exit 0
