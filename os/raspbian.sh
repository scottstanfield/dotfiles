#!/usr/bin/env bash
# vim:ft=sh ts=4 sw=4 et
set -Eeuo pipefile

# Preferred way to cd to where this script is running
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
readonly _D="$(dirname "$(readlink -f "$0")")" && cd "$_D"

# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
die() {
    local ret=$?
    printf "%s\n" "$@" >&2
    exit "$ret"
}
require() { hash "$@" 2>&- || exit 127; }
println() { printf '%s\n' "$*"; }

# vcgencmd pmic_read_adc

[[ $EUID -eq 0 ]] || die "$0 must be run as root"

function touched {
    grep -qF "##moabian" "$1"
}

#
# Tabs below are STET
function use-US-locale {
    touched /etc/locale.gen && return

    cat <<-EOF >>/etc/locale.gen
		##moabian
		en_US.UTF-8 UTF-8
	EOF
    locale-gen en_US.UTF-8
    update-locale LANG=en_US.UTF-8
}

function use-large-console-font {
    touched /etc/default/console-setup && return

    cat <<-EOF >>/etc/default/console-setup
		##moabian
		FONTFACE="TerminusBold"
		FONTSIZE="10x20"
	EOF
}

function install-packages {
    local packages=(
        bats
        fd-find
        fzf
        git
        minicom
        neovim
        raspi-gpio
        ripgrep
        tmux
        vim
        zsh
        httpie
        pigz
        pydf
        glances
        htop
        tree
        neofetch
        jq
    )

    sudo apt-get install -y ${packages[*]}
}

function install-rust {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    cargo install eza
}

function install-docker {
    curl -sSL https://get.docker.com | sh
    usermod -aG docker scott
}

function install-julia {
    curl -fsSL https://install.julialang.org | sh
}

function install-golang {
    curl -fsSL https://install.julialang.org | sh
}

use-US-locale
use-large-console-font
install-packages
install-docker
install-julia

cd
git clone --depth=1 git@github.com:scottstanfield/moabian

sudo apt-get install -y neovim zsh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install eza # takes 5 minutes on RPi 4!
