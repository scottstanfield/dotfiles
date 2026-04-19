#!/usr/bin/env bash

# this is meant to be sourced like this:
# . os/mise.sh

if ! command -v mise &>/dev/null; then
    bash <(curl --fail --silent --show-error --location https://mise.run)
    export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
fi

mise trust
mise install
