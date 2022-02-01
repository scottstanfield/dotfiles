#!/usr/bin/env bash
# vim:filetype=sh:

# dmz: Setup my Dotfiles / viM / zshrc / gitconfig
# http://git.io/dmz

# idempotent bash: https://arslan.io/2019/07/03/how-to-write-idempotent-bash-scripts/
# https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md
set -o errexit  # Exit on error. Append "|| true" if you expect an error.
set -o errtrace # Exit on error inside any functions or subshells.
set -o nounset  # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o pipefail # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`

##
## Preconditions
##
require() { hash "$@" || exit 127; }
println() { printf '%s\n' "$*"; }
die()     { ret=$?; printf "%s\n" "$@" >&2; exit "$ret"; }


require curl
require nvim
require git

# Change directories to where this script is located
#cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
canonical=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")
cd $canonical



##
## Start here
##

# Create temp folder for important files to backup
B=$(mktemp -d /tmp/dotfiles.XXXX)
println "Backing up important files to $B"

link() {
  if [[ -e $1 ]]; then
	println "linking $1 -> $2 with backup to $B"
	cp -pL "$2" "$B" 2>/dev/null || true						# (p)reserve attributes and deference symbolic links
	ln -sf "$PWD/$1" "$2"
  fi
}

# Setup zshrc

# Setup neovim
mkdir -p "$HOME"/.config/nvim
mkdir -p "$HOME"/.config/alacritty

link config/nvim/init.vim "$HOME"/.config/nvim/init.vim
link zshrc                "$HOME"/.zshrc
link zlogin               "$HOME"/.zlogin
link vimrc                "$HOME"/.vimrc						# minimal vimrc for VIM v8
link tmux.conf            "$HOME"/.tmux.conf
link bashrc               "$HOME"/.bashrc
link bash_profile         "$HOME"/.bash_profile
link inputrc              "$HOME"/.inputrc
link config/alacritty/alacritty.yml        "$HOME"/.config/alacritty/alacritty.yml
link p10k.zsh             "$HOME"/.p10k.zsh
link gitconfig            "$HOME"/.gitconfig
link gitignore            "$HOME"/.gitignore
link vimrc_background     "$HOME"/.vimrc_background

# This is the stupidest name for an app yet. And it should be in .config/.hammerspoon
mkdir -p "$HOME"/.hammerspoon
link init.lua "$HOME"/.hammerspoon

# put your [user] settings here
touch "$HOME"/.gitconfig.local			

# fixing potential insecure group writable folders
# compaudit | xargs chmod g-w

# Setup termcap for tmux
# Italics + true color + iTerm + tmux + vim
# https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be
# Understanding TERM strings 
# https://sanctum.geek.nz/arabesque/term-strings/
# tic -x termcap/tmux-256color.terminfo || true
# tic -x termcap/xterm-256color-italic.terminfo || true

# Setup empty .ssh folder in case one doesn't exist
umask 077 
mkdir -p $HOME/.ssh

# Install neovim plugins
# println "Installing vim plugins..."
# nvim +PlugInstall +qall

# # now change shells
# println 'and: sudo chsh -s $(which zsh) $(whoami)'

println "Backed up existing files to $B"
ls $B

exit 0

# Do this for alacritty
# npx alacritty-themes Dracula
