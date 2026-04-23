#!/usr/bin/env bash
# Health check for this dotfiles install. Mimics nvim :checkhealth.
# Never mutates state; safe to run any time.

set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"

source "$(dirname "$0")/lib/colors.sh"
colors_init "$@"

# check_link <link_path> <expected_relative_target>
# Verify that link_path is a symlink into $DOTFILES_DIR/<expected_relative_target>.
check_link() {
    local link="$1" expected_rel="$2" expected target
    expected="$DOTFILES_DIR/$expected_rel"
    if [[ ! -L $link ]]; then
        if [[ -e $link ]]; then
            fail "$link exists but is not a symlink"
        else
            fail "$link missing"
        fi
        return
    fi
    target=$(readlink "$link")
    if [[ $target == "$expected" ]]; then
        ok "$link → $expected_rel"
    else
        warn "$link → $target (expected $expected_rel)"
    fi
}

check_file() {
    if [[ -f $1 ]]; then ok "$1"; else fail "$1 missing"; fi
}

check_bin() {
    if command -v "$1" >/dev/null 2>&1; then
        ok "$1"
    else
        fail "$1 not on PATH"
    fi
}

# ---- checks ----

section "Environment"
ok "DOTFILES_DIR    = $DOTFILES_DIR"
ok "XDG_CONFIG_HOME = $XDG_CONFIG_HOME"
ok "XDG_DATA_HOME   = $XDG_DATA_HOME"

section "Symlinks — config/ → \$XDG_CONFIG_HOME"
for pkg in "$DOTFILES_DIR"/config/*/; do
    [[ -d $pkg ]] || continue
    name=$(basename "$pkg")
    check_link "$XDG_CONFIG_HOME/$name" "config/$name"
done

section "Symlinks — home/ → ~/.*"
for pkg in "$DOTFILES_DIR"/home/*; do
    [[ -e $pkg ]] || continue
    name=$(basename "$pkg")
    check_link "$HOME/.$name" "home/$name"
done

section "Symlinks — zsh/ → ~/.*"
for pkg in "$DOTFILES_DIR"/zsh/*; do
    [[ -e $pkg ]] || continue
    name=$(basename "$pkg")
    check_link "$HOME/.$name" "zsh/$name"
done

section "Machine-local templates (real files, not symlinks)"
check_file "$HOME/.zshrc.local"
check_file "$HOME/.gitconfig.local"

section "mise"
if command -v mise >/dev/null 2>&1; then
    ok "mise on PATH ($(mise --version 2>/dev/null))"
else
    fail "mise not on PATH"
fi
check_link "$XDG_CONFIG_HOME/mise/conf.d/baseline.toml" "templates/mise-baseline.toml"
if [[ -L "$XDG_CONFIG_HOME/mise/conf.d/extras.toml" ]]; then
    check_link "$XDG_CONFIG_HOME/mise/conf.d/extras.toml" "templates/extras.toml"
else
    note "extras.toml not linked (run ./extras.sh to enable the dev pack)"
fi
if [[ -L "$XDG_CONFIG_HOME/mise/config.toml" ]]; then
    fail "~/.config/mise/config.toml is a symlink — should be a real file (mise use -g writes here)"
elif [[ -e "$XDG_CONFIG_HOME/mise/config.toml" ]]; then
    ok "config.toml is a real file (experiment scratchpad)"
else
    note "config.toml absent — no experiments yet, fine"
fi

section "Baseline tools on PATH"
for bin in bat delta difft duf eza fd fzf glow jq lazygit nvim rg tmux uv yq; do
    check_bin "$bin"
done

if [[ "$(uname)" == "Darwin" ]]; then
    section "GNU core utils installed on Mac OS"
    for bin in gsed gawk; do
        check_bin "$bin"
    done
fi

section "Plugins"
if [[ -d "$XDG_DATA_HOME/tmux/plugins/tpm" ]]; then
    ok "tpm installed"
else
    warn "tpm not installed (re-run ./istow.sh once tmux is on PATH)"
fi
nvim_plugged="$XDG_DATA_HOME/nvim/plugged"
if [[ -d $nvim_plugged ]]; then
    count=$(find "$nvim_plugged" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    ok "nvim plugins ($count installed at $nvim_plugged)"
else
    warn "nvim plugins not installed (re-run ./istow.sh once nvim is on PATH)"
fi

section "Summary"
if (( ERRORS == 0 && WARNINGS == 0 )); then
    printf '  %sAll checks passed.%s\n\n' "$GREEN" "$RESET"
elif (( ERRORS == 0 )); then
    printf '  %s%d warning(s)%s\n\n' "$YELLOW" "$WARNINGS" "$RESET"
else
    printf '  %s%d error(s)%s, %s%d warning(s)%s\n\n' "$RED" "$ERRORS" "$RESET" "$YELLOW" "$WARNINGS" "$RESET"
fi

exit $(( ERRORS > 0 ))
