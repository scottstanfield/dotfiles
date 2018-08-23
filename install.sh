#!/usr/bin/env bash

cd `dirname $0`
set -e 

# dmz: Setup my Dotfiles / viM / zshrc / gitconfig
# http://git.io/dmz

# assumes you have zsh and neovim installed
# destroys existing links

link() {
  echo "Linking:" $PWD/$1 "->" $2
  ln -sf $PWD/$1 $2
}

# Setup zshrc
link zshrc ~/.zshrc

# Setup neovim
mkdir -p ~/.config/nvim
link config/nvim/init.vim ~/.config/nvim/init.vim

# Setup R
mkdir -p ~/.R/lib
link R/Makevars ~/.R/Makevars
link Rprofile ~/.Rprofile

# Setup git
link gitconfig ~/.gitconfig
link gitignore ~/.gitignore

# Setup tmux
link tmux.conf ~/.tmux.conf

# Setup ag (the silver search)
# Mac:   brew install the_silver_searcher
# Linux: sudo apt install silversearcher-ag
link agignore ~/.agignore


# Cloning zsh plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
	$PWD/plugins/zsh-syntax-highlighting


# Post-install step
echo 'launchng nvim to run :PlugInstall...'
nvim +PlugInstall +qall


