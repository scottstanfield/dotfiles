#!/usr/bin/env bash
# vim:filetype=sh:

# dmz: Setup my Dotfiles / viM / zshrc / gitconfig using GNU Stow
# http://git.io/dmz

set -o errexit  # Exit on error. Append "|| true" if you expect an error.
set -o errtrace # Exit on error inside any functions or subshells.
set -o nounset  # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o pipefail # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`

##
## Helpers
##
println() { printf '%s\n' "$*"; }
die()     { ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }

# Require stow
command -v stow >/dev/null 2>&1 || die "GNU stow is required. Install it first (brew install stow / apt install stow)"
command -v git >/dev/null 2>&1 || die "git is required"
command -v nvim >/dev/null 2>&1 || die "neovim is required"

# Change directories to where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

##
## Stow packages
##
println "Stowing packages..."

# Main dotfiles (all platforms)
println "  -> home"
stow -v -d packages -t "$HOME" home

# OS-specific packages
case "$(uname)" in
    Darwin)
        println "  -> macos"
        stow -v -d packages -t "$HOME" macos
        ;;
    Linux)
        if [[ -d packages/linux ]]; then
            println "  -> linux"
            stow -v -d packages -t "$HOME" linux
        fi
        ;;
esac

##
## Copy template files (no-clobber)
##
println "Setting up template files..."
if [[ ! -f ~/.machine ]]; then
    cp templates/machine.template ~/.machine
    println "  -> Created ~/.machine (edit this for machine-specific settings)"
fi

if [[ ! -f ~/.gitconfig.local ]]; then
    cp templates/gitconfig.local.template ~/.gitconfig.local
    println "  -> Created ~/.gitconfig.local (edit this for local git settings)"
fi

##
## Create required directories
##
mkdir -p ~/.ssh

##
## Install neovim plugins
##
println "Installing vim plugins..."
nvim --headless +PlugInstall +qa
nvim --headless +TSUpdate +qa

./neovim.plugins.sh

println ""
println "Done! You may need to restart your shell."
exit 0
