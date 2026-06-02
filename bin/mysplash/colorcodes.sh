#!/usr/bin/env bash

source "../../lib/colors.sh"
colors_init "$@"

ccc()  { printf '  \e[%sm%s %s\n' "$1" "$1" $RESET; }


BOLD=$'\e[1m';   RESET=$'\e[0m'
RED=$'\e[31m';   

ccc "38;5;210"
ccc "38;5;84"
ccc "38;5;147"
ccc "38;5;200"
ccc "38;5;44"
ccc "38;5;75"
ccc "38;5;123"
ccc "38;5;124"
