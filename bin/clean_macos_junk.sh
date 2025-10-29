#!/usr/bin/env bash
# Remove macOS metadata files from a directory tree (macOS & Linux)
# Supports dry-run to preview what would be deleted.
# Usage:
#   ./clean_macos_junk.sh [--dry-run|-n] [--verbose|-v] [DIR]
# Default DIR is current directory.

set -Eeuo pipefail
IFS=$'\n\t'

DRYRUN=0
VERBOSE=0
ROOT="."

log() { (( VERBOSE )) && printf '%s\n' "$*"; }

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] [DIR]

Remove macOS metadata "junk" files:
  - .DS_Store
  - ._* (AppleDouble resource forks)
  - .Spotlight-V100 (dir)
  - .Trashes (dir)
  - .fseventsd (dir)

Options:
  -n, --dry-run   Show what would be deleted without deleting
  -v, --verbose   Print extra information
  -h, --help      Show this help and exit

DIR defaults to the current directory.
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRYRUN=1; shift;;
    -v|--verbose) VERBOSE=1; shift;;
    -h|--help) usage; exit 0;;
    --) shift; break;;
    -*)
      printf 'Error: unknown option: %s\n' "$1" >&2
      usage; exit 2
      ;;
    *)
      ROOT="$1"; shift;;
  esac
done

# Normalize ROOT to an absolute path (no external deps)
if [[ "$ROOT" != /* ]]; then
  ROOT="$(cd "$ROOT" && pwd)"
fi

if [[ ! -d "$ROOT" ]]; then
  printf 'Error: not a directory: %s\n' "$ROOT" >&2
  exit 2
fi

log "Root: $ROOT"
(( DRYRUN )) && log "Mode: DRY RUN (no deletions)" || log "Mode: LIVE (will delete)"
log "Finding targets…"

# Helper to delete with dry-run support
del() {
  # usage: del [-d] path
  # -d means directory recursive delete
  local is_dir=0
  if [[ "${1:-}" == "-d" ]]; then
    is_dir=1
    shift
  fi
  local p="$1"
  if (( DRYRUN )); then
    if (( is_dir )); then
      printf '[DRY-RUN] rm -rf -- %q\n' "$p"
    else
      printf '[DRY-RUN] rm -f  -- %q\n' "$p"
    fi
  else
    if (( is_dir )); then
      rm -rf -- "$p"
    else
      rm -f -- "$p"
    fi
  fi
}

# Delete files first, then directories. Use -print0 for safety.
# 1) Files: .DS_Store and AppleDouble resource forks ._*
log "Scanning files: .DS_Store and ._*"
while IFS= read -r -d '' f; do
  printf '%s\n' "FILE: $f" | { (( VERBOSE )) && cat || true; }
  del "$f"
done < <(find "$ROOT" -type f \( -name '.DS_Store' -o -name '._*' \) -print0)

# 2) Directories: .Spotlight-V100, .Trashes, .fseventsd
# Use -prune to avoid descending into them after matched, and -depth-like behavior by deleting files first anyway.
log "Scanning directories: .Spotlight-V100, .Trashes, .fseventsd"
while IFS= read -r -d '' d; do
  printf '%s\n' "DIR:  $d" | { (( VERBOSE )) && cat || true; }
  del -d "$d"
done < <(find "$ROOT" -type d \( -name '.Spotlight-V100' -o -name '.Trashes' -o -name '.fseventsd' \) -print0)

log "Done."
