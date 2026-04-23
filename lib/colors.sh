#!/usr/bin/env bash
# colors.sh — source this file to get terminal color helpers.
#
# Usage:
#   source /path/to/colors.sh
#   colors_init "$@"          # pass your script's args to respect --color flag
#
# Color control (checked in order):
#   --color=always|never|auto   CLI flag (auto is default)
#   -C                          force colors on (short flag)
#   FORCE_COLOR=1               force colors on
#   NO_COLOR=1                  disable colors (https://no-color.org)
#   TERM=dumb                   disable colors

# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

_colors_parse_flag() {
    for arg in "$@"; do
        case "$arg" in
            --color=always) echo "on";   return ;;
            --color=never)  echo "off";  return ;;
            --color=auto)   echo "auto"; return ;;
            --color)        echo "on";   return ;;
            -C)             echo "on";   return ;;
        esac
    done
    echo "auto"
}

_colors_init() {
    local mode="${1:-auto}"
    local use_color=0

    case "$mode" in
        on)  use_color=1 ;;
        off) use_color=0 ;;
        auto)
            if   [[ "${FORCE_COLOR:-}" == "1" ]]; then use_color=1
            elif [[ -n "${NO_COLOR:-}" ]];         then use_color=0
            elif [[ "${TERM:-}" == "dumb" ]];      then use_color=0
            elif [[ ! -t 1 ]];                     then use_color=0
            else use_color=1
            fi
            ;;
    esac
    
    # 8 basic color codes from the original 1978 DEC VT100 & 1979 ANSI X3.64 spec
    if [[ $use_color -eq 1 ]]; then
        BOLD=$'\e[1m';   RESET=$'\e[0m'
        RED=$'\e[31m';   GREEN=$'\e[32m'
        YELLOW=$'\e[33m'; DIM=$'\e[2m'
    else
        BOLD=''; RESET=''; RED=''; GREEN=''; YELLOW=''; DIM=''
    fi

    export BOLD RESET RED GREEN YELLOW DIM
}

# ---------------------------------------------------------------------------
# Public init — call with your script's args
# ---------------------------------------------------------------------------

colors_init() { _colors_init "$(_colors_parse_flag "$@")"; }

# Default: auto-init on source
_colors_init auto

# ---------------------------------------------------------------------------
# Counters
# ---------------------------------------------------------------------------

WARNINGS=0
ERRORS=0

colors_reset_counts() { WARNINGS=0; ERRORS=0; }

# ---------------------------------------------------------------------------
# Logging helpers
# ---------------------------------------------------------------------------

section() { printf '\n%s%s%s\n' "$BOLD"    "$*" "$RESET"; }
ok()      { printf '  %s✓%s %s\n' "$GREEN"  "$RESET" "$*"; }
warn()    { printf '  %s!%s %s\n' "$YELLOW" "$RESET" "$*"; WARNINGS=$((WARNINGS+1)); }
fail()    { printf '  %s✗%s %s\n' "$RED"    "$RESET" "$*"; ERRORS=$((ERRORS+1)); }
note()    { printf '    %s%s%s\n' "$DIM"    "$*"     "$RESET"; }
