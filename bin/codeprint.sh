#!/bin/bash

set -e

if [ $# -eq 0 ]; then
  echo "Usage: $0 <file> [enscript options]"
  exit 1
fi

FILE="$1"
shift

if [ ! -f "$FILE" ]; then
  echo "Error: file '$FILE' not found"
  exit 1
fi

TMPPS=$(mktemp /tmp/print_XXXXXX.ps)
TMPPDF=$(mktemp /tmp/print_XXXXXX.pdf)

cleanup() {
  rm -f "$TMPPS" "$TMPPDF"
}
trap cleanup EXIT

#enscript --margins=36:36:36:36 --font=LucidaSansTypewriter12 --highlight -2 -r -o "$TMPPS" "$@" "$FILE"
enscript --margins=36:36:36:36 --font=Courier12 --highlight -2 -r -o "$TMPPS" "$@" "$FILE"
ps2pdf "$TMPPS" "$TMPPDF"
open "$TMPPDF"
lpr "$TMPPDF"

echo "Printed: $FILE"
