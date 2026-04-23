#!/usr/bin/env bash
# Run from the completions/ directory to refresh all zsh completion files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating zsh completions..."

curl -s -o "$SCRIPT_DIR/_eza" \
    https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza

curl -s -o "$SCRIPT_DIR/_fd" \
    https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd

curl -s -o "$SCRIPT_DIR/_rg" \
    https://raw.githubusercontent.com/BurntSushi/ripgrep/master/complete/_rg

curl -s -o "$SCRIPT_DIR/_bat" \
    https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.zsh.in

curl -s -o "$SCRIPT_DIR/_bun" \
    https://raw.githubusercontent.com/oven-sh/bun/main/completions/bun.zsh

# rg can also self-generate — overwrite if available
if type rg > /dev/null 2>&1; then
    rg --generate complete-zsh > "$SCRIPT_DIR/_rg"
fi

echo "Done."