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

brew install pkg-config

# Setup R
mkdir -p $HOME/.R/lib
mkdir -p $HOME/.R/tmp

# The line below is for clang/llvm, which is Mac specific
# Skip for now until cross platform soution
cp --no-clobber Makevars $HOME/.R/Makevars

cp --no-clobber Rprofile $HOME/.Rprofile
