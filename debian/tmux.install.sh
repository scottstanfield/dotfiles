#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.
# https://gist.github.com/ryin/3106801#file-tmux_local_install-sh

# Assumptions:
# sudo apt-get install -y build-essentiall libssl-dev automake

# exit on error
set -e

TMUX_VER=2.8
LIBEVENT_VER=2.1.8
NCURSES_VER=6.1

# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp

# use tmux tarball (no need for autogen.sh)
wget -O tmux-${TMUX_VER}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VER}/tmux-${TMUX_VER}.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VER}-stable/libevent-${LIBEVENT_VER}-stable.tar.gz
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VER}.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-${LIBEVENT_VER}-stable.tar.gz
cd libevent-${LIBEVENT_VER}-stable
./configure --prefix=$HOME/local --disable-shared
make -j
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-${NCURSES_VER}.tar.gz
cd ncurses-${NCURSES_VER}
./configure --prefix=$HOME/local
make -j
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VER}.tar.gz
cd tmux-${TMUX_VER}
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
cp tmux $HOME/local/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp
echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
