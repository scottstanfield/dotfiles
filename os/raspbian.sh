#!/usr/bin/env bash
set -Eeo pipefail

function pause {
  >/dev/tty printf '%s' "${*:-Press any key to continue... }"
  [[ $ZSH_VERSION ]] && read -krs  # Use -u0 to read from STDIN
  [[ $BASH_VERSION ]] && </dev/tty read -rsn1
  printf '\n'
}

printf "Install neovim, zsh, rust and exa tool? It takes 5 minutes.\n"
pause 'Press SPACE to continue or CTRL-C to quit'

sudo apt-get install -y neovim zsh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install eza                       # takes 5 minutes on RPi 4!
