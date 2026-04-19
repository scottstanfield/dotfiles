#!/usr/bin/env bash
# vim:filetype=sh:
#
# https://codeberg.org/Jorenar/dotfiles

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

: ${XDG_CONFIG_HOME:=${HOME}/.config}      # user-specific portable configuration
mkdir -p $XDG_CONFIG_HOME

# Main dotfiles (all platforms)
println "  -> config"
stow --dotfiles -t ~/.config config

println "  -> home"
stow --dotfiles -t ~ home

println "  -> zsh"
stow --dotfiles -t ~ zsh

# OS-specific packages
# case "$(uname)" in
#     Darwin)
#         println "  -> macos"
#         stow -v -d packages -t "$HOME" macos
#         ;;
#     Linux)
#         if [[ -d packages/linux ]]; then
#             println "  -> linux"
#             stow -v -d packages -t "$HOME" linux
#         fi
#         ;;
# esac

##
## Copy template files (no-clobber)
##
println "Setting up template files..."
if [[ -f ~/.machine && ! -f ~/.zshrc.local ]]; then
    mv ~/.machine ~/.zshrc.local
    println "  -> Renamed ~/.machine to ~/.zshrc.local"
fi
if [[ ! -f ~/.zshrc.local ]]; then
    cp templates/zshrc.local ~/.zshrc.local
    println "  -> Bootstraping prompt with ~/.zshrc.local"
fi

if [[ ! -f ~/.config/git/local ]]; then
    cp templates/gitconfig.local ~/.config/git/local
    println "  -> Created ~/.config/git/local"
    println "  Put your name and email address in here"
fi


##
## Create required directories
##
mkdir -p ~/.ssh

##
## Install tmux plugin manager
##
TPM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    println "Installing tpm..."
    mkdir -p "$(dirname "$TPM_DIR")"
    git clone -q https://github.com/tmux-plugins/tpm "$TPM_DIR"
    "$TPM_DIR/bin/install_plugins"
else
    println "tpm already installed"
fi

# 
println "Update mise now that ~/.config/mise/config.toml is linked"
mise up

##
## Install neovim plugins
##
println "Installing vim plugins..."
./neovim.plugins.sh

println ""
println "Done! You may need to restart your shell."
