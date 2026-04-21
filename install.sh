#!/usr/bin/env bash

# 100% confirmed and guided by me with Claude Code 
# as part of a big refactor. Went well.

# Install dotfiles: symlink packages into $HOME / $XDG_CONFIG_HOME,
# drop machine-local templates (no-clobber), install tpm and nvim plugins.

set -Eeuo pipefail

println() { printf '%s\n' "$*"; }
die()     { printf '%s\n' "$*" >&2; exit 1; }

command -v git  >/dev/null 2>&1 || die "git is required"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
mkdir -p "$XDG_CONFIG_HOME"

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
            println "  !! $dst exists (not a symlink), skipping"
            continue
        fi
        ln -s "$src" "$dst"
        println "  linked $dst -> $src"
    done
}

# mycopy <src> <dst>
# Copy src to dst only if dst doesn't exist. Works for files and directories.
mycopy() {
    local src="$1" dst="$2"
    if [[ -e $dst ]]; then
        println "  skip $dst (already exists)"
        return
    fi
    mkdir -p "$(dirname "$dst")"
    cp -R "$src" "$dst"
    println "  copied $src -> $dst"
}

# precondition for testing in virtual machine "lima"
# lima creates a temporary ~/.zshrc and ~/.bashrc

if [[ -v LIMA_VM ]]; then
    rm ~/.zshrc
    rm ~/.bashrc
fi


##
## Link packages
##
println "Linking packages..."
mylink config "$XDG_CONFIG_HOME"
mylink home   "$HOME"        --dot
mylink zsh    "$HOME"        --dot

##
## Machine-local templates (no-clobber)
##
println "Setting up template files..."
if [[ -f ~/.machine && ! -f ~/.zshrc.local ]]; then
    mv ~/.machine ~/.zshrc.local
    println "  renamed ~/.machine to ~/.zshrc.local"
fi
mycopy templates/zshrc.local     "$HOME/.zshrc.local"
mycopy templates/gitconfig.local "$HOME/.gitconfig.local"

##
## Required directories
##
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

if ! command -v mise >/dev/null 2>&1; then
    println "Bootstrapping mise..."
    bash <(curl --fail --silent --show-error --location https://mise.run)
fi
export PATH="$HOME/.local/bin:$XDG_DATA_HOME/mise/shims:$PATH"

mkdir -p "$XDG_CONFIG_HOME/mise/conf.d"
baseline_src="$DOTFILES_DIR/templates/mise-baseline.toml"
baseline_dst="$XDG_CONFIG_HOME/mise/conf.d/baseline.toml"
if [[ -L $baseline_dst ]]; then
    rm "$baseline_dst"
fi
if [[ -e $baseline_dst ]]; then
    println "  !! $baseline_dst exists and is not a symlink, skipping baseline link"
else
    ln -s "$baseline_src" "$baseline_dst"
    println "  linked baseline -> $baseline_src"
fi

println "Running mise up..."
mise up

##
## tmux plugin manager (skipped if tmux is not installed)
##
if command -v tmux >/dev/null 2>&1; then
    TPM_DIR="$XDG_DATA_HOME/tmux/plugins/tpm"
    if [[ ! -d "$TPM_DIR" ]]; then
        println "Installing tpm..."
        mkdir -p "$(dirname "$TPM_DIR")"
        git clone -q https://github.com/tmux-plugins/tpm "$TPM_DIR"
        "$TPM_DIR/bin/install_plugins"
    else
        println "tpm already installed"
    fi
else
    println "tmux not found; skipping tpm install. Re-run ./istow.sh after installing tmux."
fi

##
## Neovim plugins (skipped if nvim is not installed)
##
if command -v nvim >/dev/null 2>&1; then
    println "Installing vim plugins..."
    ./neovim.plugins.sh
else
    println "nvim not found; skipping neovim plugin install. Re-run ./istow.sh after installing nvim."
fi

println ""
println "Done! You may need to restart your shell."
