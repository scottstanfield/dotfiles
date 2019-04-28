#!/usr/bin/env bash

cd `dirname $0`

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
mkdir -p ~/.R/tmp
link R/Makevars ~/.R/Makevars
link Rprofile ~/.Rprofile

# minimal vimrc for vim 8
link vimrc ~/.vimrc

# Setup git
cp --no-clobber gitconfig ~/.gitconfig
link gitignore ~/.gitignore

# Setup tmux
link tmux.conf ~/.tmux.conf

# Setup bash
link bashrc ~/.bashrc
link bash_profile ~/.bash_profile


# Setup ag (the silver search)
# Mac:   brew install the_silver_searcher
# Linux: sudo apt install silversearcher-ag
link agignore ~/.agignore


# Cloning zsh plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
	$PWD/plugins/zsh-syntax-highlighting

# fixing potential insecure group writable folders
# compaudit | xargs chmod g-w


# Post-install step
echo 'launchng nvim to run :PlugInstall...'
nvim +PlugInstall +qall


