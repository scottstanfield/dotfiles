#!/usr/bin/env bash
# example.sh — demonstrates colors.sh helpers

source "$(dirname "$0")/colors.sh"
colors_init "$@"

section "System checks"
ok   "bash $BASH_VERSION detected"
warn "config file not found, using defaults"
fail "required command 'foo' not found"
note "install foo with: brew install foo"

section "Network checks"
ok   "internet reachable"
fail "VPN not connected"
note "connect with: vpn up prod"

section "Summary"
[[ $ERRORS   -gt 0 ]] && note "$ERRORS error(s)"
[[ $WARNINGS -gt 0 ]] && note "$WARNINGS warning(s)"

exit $ERRORS
