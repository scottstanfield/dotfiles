#!/usr/bin/env bash
# vim:filetype=sh:

# Bash "strict mode": http://redsymbol.net/articles/unofficial-bash-strict-mode/
# https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md
# https://betterdev.blog/minimal-safe-bash-script-template/
# set -Eeuo pipefile

set -o errexit  # Exit on error. Append "|| true" if you expect an error.
set -o errtrace # Exit on error inside any functions or subshells.
set -o nounset  # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o pipefail # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
shopt -s nullglob globstar

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
println() { local IFS=" "; printf '%s\n' "$*"; }
require() { hash "$@" 2>&- || exit 127; }
die()     { local ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

# macOS comes with a really GNU bash version 3.2
# Minimum Bash version check > 4.2. Why? For associative array safety.
# println "${BASH_VERSINFO[*]: 0:3}"
bv=${BASH_VERSINFO[0]}${BASH_VERSINFO[0]}
((bv > 42)) || die "Need Bash version 4.2 or greater. You have $BASH_VERSION"

# Preferred way to cd to where this script is running
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"
println "Location of script:" "$_D"

echo "bash_source ${BASH_SOURCE[0]}"
# From https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
println "script_dir: $SCRIPT_DIR"
println "something is stopping us before we get here"


# backup a file by appending bash
# cp filename{,.bak}

# Test passing env strings in, like VERSION=4.0 and fail if unset
# For sudoer doing the same as root: VERSION=99 sudo -Eu root bash -c 'echo $VERSION'
# if [ -z ${VERSION+x} ]; then echo "var is missing"; else echo "version is: $VERSION"; fi
