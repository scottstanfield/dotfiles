#!/usr/bin/env bash

DEST='1.1.1.1'

# ANSI colors
RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
YELLOW='\033[33m'
GREEN='\033[32m'
WHITE='\033[97m'

case "$(uname)" in
  Linux)
    route_out=$(ip route get "$DEST")
    src=$(echo "$route_out"       | grep -oE 'src \S+'     | awk '{print $2}')
    gateway=$(echo "$route_out"   | grep -oE 'via \S+'     | awk '{print $2}')
    interface=$(echo "$route_out" | grep -oE 'dev \S+'     | awk '{print $2}')
    ;;
  Darwin)
    route_out=$(route get "$DEST")
    src=$(ipconfig getifaddr "$(echo "$route_out" | grep -oE 'interface: \S+' | cut -d' ' -f2)")
    gateway=$(echo "$route_out"   | grep -oE 'gateway: \S+'  | cut -d' ' -f2)
    interface=$(echo "$route_out" | grep -oE 'interface: \S+' | cut -d' ' -f2)
    ;;
  *)
    echo "Unsupported OS: $(uname)" >&2
    exit 1
    ;;
esac

echo -e "${CYAN}${BOLD}${DEST}${RESET} via ${YELLOW}${gateway}${RESET} dev ${GREEN}${interface}${RESET} src ${BOLD}${WHITE}${src}${RESET}"
