#!/usr/bin/env bash
# vim:filetype=sh:

set -o errexit  # Exit on error. Append "|| true" if you expect an error.
set -o errtrace # Exit on error inside any functions or subshells.
set -o nounset  # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o pipefail # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
shopt -s nullglob globstar

##
## Start here
##

# Setup R
mkdir -p $HOME/.R/lib
mkdir -p $HOME/.R/tmp
cp --no-clobber Makevars $HOME/.R/Makevars
cp --no-clobber Rprofile $HOME/.Rprofile
