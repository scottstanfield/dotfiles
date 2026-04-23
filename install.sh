#!/usr/bin/env bash

# 100% confirmed and guided by me with Claude Code 
# as part of a big refactor. Went well.

# Install dotfiles: symlink packages into $HOME / $XDG_CONFIG_HOME,
# drop machine-local templates (no-clobber), install tpm and nvim plugins.

set -Eeuo pipefail

println() { printf '%s\n' "$*"; }
die()     { printf '%s\n' "$*" >&2; exit 1; }
in_path() { command -v "$1" &>/dev/null; }

# Require bash 4+
if (( BASH_VERSINFO[0] < 4 )); then
    die "bash 4+ required (you have ${BASH_VERSION}). Install with: brew install bash"
fi

source "$(dirname "$0")/lib/colors.sh"
colors_init "$@"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

in_path git || die "git is required"

: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CONFIG_HOME:=$HOME/.config}"
section "Creating ${XDG_DATA_HOME} and ${XDG_CONFIG_HOME}"
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"

##
## Linking and copy helpers (replaces GNU stow for this repo)
##

# mylink <pkg_dir> <target_dir> [--dot]
# Symlink each top-level entry of pkg_dir into target_dir. --dot prepends '.'
# to the target name (zshrc -> .zshrc). Works for files and directories.
# Refreshes existing symlinks; warns and skips on existing real files/dirs.
mylink() {
    local pkg="$1" target="$2" dot=""
    [[ "${3:-}" == "--dot" ]] && dot="."
    local abs_pkg
    abs_pkg=$(cd "$pkg" && pwd)
    mkdir -p "$target"
    for src in "$abs_pkg"/*; do
        [[ -e $src ]] || continue
        local dst="$target/${dot}$(basename "$src")"
        if [[ -L $dst ]]; then
            rm "$dst"
        elif [[ -e $dst ]]; then
            note "$dst exists (not a symlink), skipping"
            continue
        fi
        ln -s "$src" "$dst"
        ok "linked $dst -> $src"
    done
}

# mycopy <src> <dst>
# Copy src to dst only if dst doesn't exist. Works for files and directories.
mycopy() {
    local src="$1" dst="$2"
    if [[ -e $dst ]]; then
        note "skip $dst (already exists)"
        return
    fi
    mkdir -p "$(dirname "$dst")"
    cp -R "$src" "$dst"
    ok "copied $src -> $dst"
}

# precondition for testing in virtual machine "lima"
# lima creates a temporary ~/.zshrc and ~/.bashrc

if [[ -n "${LIMA_VM:-}" ]]; then
    rm -f ~/.zshrc ~/.bash_logout ~/.bashrc ~/.profile
fi

##
## Link packages
##
section "Linking ~/.config ~/bin ~/.zsh* and ~/.bash*"
mylink config "$XDG_CONFIG_HOME"
mylink home   "$HOME"        --dot
mylink zsh    "$HOME"        --dot
mylink bin    "$HOME/bin"
mylink hammerspoon "$HOME/.hammerspoon"

##
## Machine-local templates (no-clobber)
##
section "Setting up template files..."
if [[ -f ~/.machine && ! -f ~/.zshrc.local ]]; then
    mv ~/.machine ~/.zshrc.local
    ok "renamed ~/.machine to ~/.zshrc.local"
fi
mycopy templates/zshrc.local     "$HOME/.zshrc.local"
mycopy templates/gitconfig.local "$HOME/.gitconfig.local"

##
## Required directories
##
section "Ensuring ~/.ssh directory permission"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

##
## Bootstrap mise (if missing) and install baseline tools.
## Running this first so the downstream tpm and nvim-plugin steps can find
## mise-managed tmux/nvim on PATH.
##
## Baseline tools are tracked in templates/mise-baseline.toml and symlinked
## into ~/.config/mise/conf.d/ so mise's own ~/.config/mise/config.toml
## stays a real, untracked file that `mise use -g <tool>` can mutate freely
## without dirtying this repo.
##

section "Installing mise"
if ! command -v mise >/dev/null 2>&1; then
    note "Installing from https://mise.run"
    bash <(curl --fail --silent --show-error --location https://mise.run)
else
    note "Checking for mise updates"
    mise self-update
fi
export PATH="$HOME/.local/bin:$XDG_DATA_HOME/mise/shims:$PATH"

mkdir -p "$XDG_CONFIG_HOME/mise/conf.d"
baseline_src="$DOTFILES_DIR/templates/mise-baseline.toml"
baseline_dst="$XDG_CONFIG_HOME/mise/conf.d/baseline.toml"
if [[ -L $baseline_dst ]]; then
    rm "$baseline_dst"
fi
if [[ -e $baseline_dst ]]; then
    warn "$baseline_dst exists and is not a symlink, skipping baseline link"
else
    ln -s "$baseline_src" "$baseline_dst"
    ok "linked baseline -> $baseline_src"
fi

section "Running mise up..."
mise up

##
## tmux plugin manager (skipped if tmux is not installed)
##
section "tmux"
if in_path tmux; then
    TPM_DIR="$XDG_DATA_HOME/tmux/plugins/tpm"
    if [[ ! -d "$TPM_DIR" ]]; then
        println "Installing tpm..."
        mkdir -p "$(dirname "$TPM_DIR")"
        git clone -q https://github.com/tmux-plugins/tpm "$TPM_DIR"
        "$TPM_DIR/bin/install_plugins"
    fi
else
    warn "tmux not found; skipping tpm install. Re-run ./install.sh after installing tmux."
fi

section "Brew packages"
# Map package name -> binary to check
declare -A brew_pkgs=(
    [coreutils]=gls
    [gnu-sed]=gsed
    [gawk]=gawk
)

if in_path brew; then
    for pkg in "${!brew_pkgs[@]}"; do
        bin="${brew_pkgs[$pkg]}"
        if ! in_path "$bin"; then
            brew install "$pkg"
            ok "installed $pkg ($bin)"
        else
            note "$pkg already installed"
        fi
    done
fi

##
## Neovim plugins (skipped if nvim is not installed)
##
section "neovim"
if in_path nvim; then
    note "Installing vim plugins..."

    rm -rf $XDG_DATA_HOME/nvim/site
    curl -SsfLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    nvim --headless +PlugInstall  +qa
    nvim --headless +TSUpdate +qa
else
    warn "nvim not found; skipping neovim plugin install. Re-run ./install.sh after installing nvim."
fi

echo
ok "You may need to restart your shell."
