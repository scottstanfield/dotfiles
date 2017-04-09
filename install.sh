#!/bin/sh

# dmz: Setup my Dotfiles / viM / zshrc / gitconfig
# assumes you have zsh and neovim installed
# destroys existing links

function link {
  echo "Linking:" $PWD/$1 "->" $2
  ln -sfb $PWD/$1 $2
}

# Setup zshrc
link zshrc ~/.zshrc

# Setup neovim
mkdir -p ~/.config/nvim
link config/nvim/init.vim ~/.config/nvim/init.vim

# Setup R
mkdir -p ~/R/library
link R/Makevars ~/.R/Makevars
link Renviron ~/.Renviron
link Rprofile ~/.Rprofile

# Setup gitconfig
link gitconfig ~/.gitconfig

# Setup go
mkdir -p ~/go

# Post-install step
echo 'launchng nvim to run :PlugInstall...'
nvim +PlugInstall +qall



