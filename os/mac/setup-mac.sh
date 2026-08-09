#!/usr/bin/env bash
# One-command macOS setup: chains the bootstrap steps and, optionally,
# the opinionated system defaults.
#
#   1. os/mac/macos-cli.sh       Xcode Command Line Tools + XDG dirs (idempotent)
#   2. ./install.sh              symlink configs, bootstrap mise, install plugins
#   2b. verify_git               confirm git / GitHub identity
#   2c. verify_host_identity     show whoami + hostname; prompt only if none resolves
#   2d. checkpoint               pause for the user to confirm the identity above
#   3. claude-setup/setup.sh     install Claude Code + link ~/.claude config
#   4. os/mac/macos-defaults.sh  (opt-in) `defaults write` system preferences
#
# Steps 1-3 are safe to re-run any time. Step 4 mutates system state
# (kills apps, wants a logout/restart), so it is prompted, not automatic.
# It stays a separate script on purpose — see os/mac/macos-defaults.sh.

set -Eeuo pipefail

println() { printf '%s\n' "$*"; }
die()     { printf '%s\n' "$*" >&2; exit 1; }

readonly _D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # os/mac/
readonly _REPO="$(cd "$_D/../.." && pwd)"                     # repo root

[[ "$(uname)" == "Darwin" ]] || die "This script is for macOS. Use os/linux/debian.sh on Linux."

# Show the effective git identity (from ~/.gitconfig.local via ~/.config/git)
# and GitHub CLI auth, so a fresh setup can confirm commits are attributed
# correctly. Run from $HOME so we report the user-level identity, not any
# repo-local override.
verify_git() {
    println ""
    println "==> Git / GitHub configuration"

    local name email origin
    name="$(git -C "$HOME" config user.name  2>/dev/null || true)"
    email="$(git -C "$HOME" config user.email 2>/dev/null || true)"

    if [[ -z "$name" || -z "$email" ]]; then
        println "  ! git identity incomplete  (name: ${name:-<unset>}, email: ${email:-<unset>})"
        println "    Set it in ~/.gitconfig.local:"
        println "      git config --file ~/.gitconfig.local user.name  \"Your Name\""
        println "      git config --file ~/.gitconfig.local user.email \"you@example.com\""
    elif [[ "$email" == "someone@example.com" || "$name" == "Git Config dot Local" ]]; then
        println "  ! git identity is still the template placeholder ($name <$email>)"
        println "    Edit ~/.gitconfig.local with your real name and email."
    else
        origin="$(git -C "$HOME" config --show-origin user.email 2>/dev/null \
                  | awk '{print $1}' | sed 's|^file:||')"
        println "  git identity : $name <$email>"
        println "  from         : ${origin:-?}"
    fi

    if command -v gh >/dev/null 2>&1; then
        if gh auth status >/dev/null 2>&1; then
            local acct
            acct="$(gh auth status 2>&1 | sed -n 's/.*Logged in to [^ ]* account \([^ ]*\).*/\1/p' | head -1)"
            println "  GitHub CLI   : logged in as ${acct:-?}"
        else
            println "  GitHub CLI   : installed but NOT logged in  (run: gh auth login)"
        fi
    else
        println "  GitHub CLI   : gh not installed (optional)"
    fi
}

# Show the login user (whoami — always set) and the macOS hostname. A fresh
# Mac often leaves HostName unset, so prompt to set one; the shell prompt and
# networking otherwise fall back to a generic default.
verify_host_identity() {
    println ""
    println "==> Host / user identity"
    println "  user (whoami) : $(whoami)"

    local computer hostn localh
    computer="$(scutil --get ComputerName 2>/dev/null || true)"
    hostn="$(scutil --get HostName 2>/dev/null || true)"
    localh="$(scutil --get LocalHostName 2>/dev/null || true)"
    println "  ComputerName  : ${computer:-<unset>}"
    println "  HostName      : ${hostn:-<unset>}"
    println "  LocalHostName : ${localh:-<unset>}"
    println "  hostname      : $(hostname)"

    # Consider the hostname configured if HostName is set, OR the effective
    # hostname already resolves to a real name. macOS derives `hostname`
    # (e.g. MacBook-Air.local) from LocalHostName when HostName is unset, so
    # that already works for shells and Bonjour — don't nag in that case.
    if [[ -n "$hostn" ]] || { [[ -n "$localh" && "$localh" != "localhost" ]]; }; then
        return
    fi

    local newhost
    read -rp "  No hostname is configured. Enter one (blank to skip): " newhost || true
    [[ -z "$newhost" ]] && { println "  skipped hostname setup"; return; }

    # LocalHostName must be a single DNS label: letters, digits, hyphens only.
    local localname
    localname="$(printf '%s' "${newhost// /-}" | tr -cd 'A-Za-z0-9-')"

    sudo scutil --set ComputerName  "$newhost"
    sudo scutil --set HostName      "$newhost"
    sudo scutil --set LocalHostName "$localname"
    println "  set: ComputerName='$newhost'  HostName='$newhost'  LocalHostName='$localname'"
}

##
## 1. Platform prep (Xcode CLT + XDG dirs). No Homebrew.
##
println "==> os/mac/macos-cli.sh"
"$_D/macos-cli.sh"

##
## 2. Symlinks, mise, plugins.
##
println ""
println "==> install.sh"
"$_REPO/install.sh" "$@"

##
## 2b. Confirm git / GitHub identity is set up correctly.
##
verify_git

##
## 2c. Show user + hostname; prompt to set a hostname if none is configured.
##
verify_host_identity

##
## 2d. Checkpoint — pause so the identity above isn't lost in the scrollback.
##
println ""
println "------------------------------------------------------------------"
read -rp "Does the git + host identity above look correct? [Y/n] " id_ok || true
if [[ "$id_ok" == [nN]* ]]; then
    die "Stopped at identity check. Fix ~/.gitconfig.local (git) or set a hostname, then re-run os/mac/setup-mac.sh."
fi

##
## 3. Claude Code — base personal setup (install + link ~/.claude config).
##
println ""
println "==> claude-setup/setup.sh"
"$_REPO/claude-setup/setup.sh"

##
## 4. Opinionated system defaults (opt-in). Mutating; needs logout/restart.
##
println ""
read -rp "Apply opinionated macOS system defaults now (os/mac/macos-defaults.sh)? [y/N] " reply
if [[ "$reply" == [yY] ]]; then
    println "==> os/mac/macos-defaults.sh"
    "$_D/macos-defaults.sh"   # prints its own "Changes applied" summary
else
    println "Skipped system defaults. Run os/mac/macos-defaults.sh yourself when ready."
fi

println ""
println "Done. Open a new shell (or 'exec zsh') to pick up the environment."
