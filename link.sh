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
msg()     { echo >&2 -e "${1-}"; }

require curl 
require git 
require tmux

# Change directories to where this script is located
#cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
canonical=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)") 
cd "$canonical"

# Create temp folder for all the files being backed up
B=$(mktemp -d /tmp/dotfiles.XXXX)
println "Backing up your config files to $B"

link() {
    if [[ -e $1 ]]; then
        println "$1 -> $2"
        cp -pL "$2" "$B" 2>/dev/null || true		# (p)reserve attributes and deference symbolic links
        mkdir -p $(dirname $2)                      # ensure target file directory exists
        ln -sf "$PWD/$1" "$2"                       # link target
    fi
}


link zshrc                           ~/.zshrc
link zlogin                          ~/.zlogin
link vimrc                           ~/.vimrc						# minimal vimrc for VIM v8
link tmux.conf                       ~/.tmux.conf
link tmux.reset.conf                 ~/.tmux.reset.conf
link bashrc                          ~/.bashrc
link bash_profile                    ~/.bash_profile
link inputrc                         ~/.inputrc
link p10k.zsh                        ~/.p10k.zsh
link gitconfig                       ~/.gitconfig
link gitignore                       ~/.gitignore
link config/nvim/init.vim            ~/.config/nvim/init.vim

link config/alacritty/alacritty.toml       ~/.config/alacritty/alacritty.toml
link config/alacritty/dracula.toml         ~/.config/alacritty/dracula.toml
if [[ ! -e ~/.alacritty.local.toml ]]; then
   cp config/alacritty/alacritty.local.toml ~/.alacritty.local.toml
fi

if [[ ! -e ~/.machine ]]; then
   cp machine ~/.machine
fi

if [[ ! -e ~/.gitconfig.local ]]; then
   cp gitconfig.local ~/.gitconfig.local
   echo "Edit your ~/.gitconfig.local to fit your username and email for git"
fi


# This is the stupidest name for an app yet. And it should be in .config/.hammerspoon
if [[ $(uname) == "Darwin" ]]; then
    link init.lua                    ~/.hammerspoon/init.lua
fi

# fixing potential insecure group writable folders
# compaudit | xargs chmod g-w

# Setup termcap for tmux
# Italics + true color + iTerm + tmux + vim
# https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be
# Understanding TERM strings 
# https://sanctum.geek.nz/arabesque/term-strings/
# tic -x termcap/tmux-256color.terminfo || true
# tic -x termcap/xterm-256color-italic.terminfo || true

# Install neovim plugins
# println "Installing vim plugins..."
# nvim +PlugInstall +qall

# # now change shells
# println 'and: sudo chsh -s $(which zsh) $(whoami)'

println "Backed up existing files to $B"
ls $B

exit 0
