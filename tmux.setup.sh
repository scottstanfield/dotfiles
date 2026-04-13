#!/usr/bin/env bash

mkdir -p ${XDG_DATA_HOME}/plugins
git clone https://github.com/tmux-plugins/tpm ${XDG_DATA_HOME}/plugins/tpm

echo "Now, launch tmux then run these two commands"
echo "tmux source ~/.tmux.conf"
echo "ctrl-O, I"
