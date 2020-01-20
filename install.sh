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

# Minimum Bash version check > 4.2. Why? For associative array safety.
# println "${BASH_VERSINFO[*]: 0:3}"
bv=${BASH_VERSINFO[0]}${BASH_VERSINFO[0]}
((bv > 42)) || die "Need Bash version 4.2 or greater. You have $BASH_VERSION"
shopt -s nullglob globstar

require nvim
require git

# Change directories to where this script is located
cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"


##
## Start here
##

# Create temp folder for important files to backup
B=$(mktemp -d /tmp/dotfiles.XXXX)
println "Backing up important files to ${B}"

link() {
  println "linking $1 -> $2 with backup to $B"
  cp -pL $PWD/$1 $B						# (p)reserve attributes and deference symbolic links
  ln -sf $PWD/$1 $2
}

# Setup zshrc

# Setup neovim
mkdir -p $HOME/.config/nvim
link config/nvim/init.vim $HOME/.config/nvim/init.vim

link zshrc        $HOME/.zshrc
link vimrc        $HOME/.vimrc						# minimal vimrc for VIM v8
link tmux.conf    $HOME/.tmux.conf
link bashrc       $HOME/.bashrc
link bash_profile $HOME/.bash_profile
link agignore     $HOME/.agignore					# brew{apt} the_silver_searcher{-ag}

cp -n  gitconfig  $HOME/.gitconfig
link   gitignore  $HOME/.gitignore

# Cloning zsh plugin
if [[ ! -d $PWD/plugins/zsh-syntax-highlighting ]]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		$PWD/plugins/zsh-syntax-highlighting
fi

# fixing potential insecure group writable folders
# compaudit | xargs chmod g-w


# Post-install step
echo 'launchng nvim to run :PlugInstall...'
nvim +PlugInstall +qall

# now change shells
echo 'sudo chsh -s $(which zsh) $(whoami)'

exit 0

