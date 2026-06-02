#!/usr/bin/env bash
# splash.sh — minimal fastfetch-style login splash. Pure bash, zero dependencies.
# Works on macOS (Darwin) and Debian/Ubuntu/Linux. Tested with bash 3.2+ (macOS) and bash 5.
set -u

# --- formatting helpers ------------------------------------------------------

plural() { [ "$1" -eq 1 ] && printf '%s %s' "$1" "$2" || printf '%s %ss' "$1" "$2"; }

fmt_uptime() {                                   # arg: seconds -> "X days, Y hours, Z mins"
    local s=$1 d h m; local -a parts=()
    d=$(( s / 86400 )); h=$(( (s % 86400) / 3600 )); m=$(( (s % 3600) / 60 ))
    (( d ))        && parts+=("$(plural "$d" day)")
    (( d || h ))   && parts+=("$(plural "$h" hour)")
    parts+=("$(plural "$m" min)")
    local out="" p; for p in "${parts[@]}"; do out+="${out:+, }$p"; done
    printf '%s' "$out"
}

mask2cidr() {                                    # arg: 0xffffff00 -> 24
    local n=$(( 16#${1#0x} )) c=0
    while (( n )); do c=$(( c + (n & 1) )); n=$(( n >> 1 )); done
    printf '%s' "$c"
}

# --- per-field collectors ----------------------------------------------------

get_computer() {
    if [ "$(uname -s)" = Darwin ]; then
        local id plist hit
        id=$(sysctl -n hw.model 2>/dev/null)     # e.g. Mac14,2 or MacBookPro16,1
        for plist in /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/*/Resources/*.lproj/SIMachineAttributes.plist; do
            [ -r "$plist" ] || continue
            hit=$(plutil -extract "$id.marketingModel" raw -o - "$plist" 2>/dev/null) \
                && [ -n "$hit" ] && { printf '%s' "$hit"; return; }
        done
        printf '%s' "${id:-Unknown}"             # fallback: bare model identifier
    else
        local pn pv
        pn=$(cat /sys/devices/virtual/dmi/id/product_name    2>/dev/null)
        pv=$(cat /sys/devices/virtual/dmi/id/product_version 2>/dev/null)
        case "$pv" in
            ""|None|"Not Specified"|"System Version"|"Default string"|\
            "To be filled by O.E.M."|"To Be Filled By O.E.M.") printf '%s' "${pn:-Unknown}" ;;
            *) printf '%s (%s)' "$pn" "$pv" ;;
        esac
    fi
}

get_os() {
    if [ "$(uname -s)" = Darwin ]; then
        local ver build code
        ver=$(sw_vers -productVersion); build=$(sw_vers -buildVersion)
        case "${ver%%.*}" in
            16) code="Tahoe" ;; 15) code="Sequoia" ;; 14) code="Sonoma" ;;
            13) code="Ventura" ;; 12) code="Monterey" ;; 11) code="Big Sur" ;;
            *)  code="" ;;
        esac
        printf 'macOS%s %s (%s) %s' "${code:+ $code}" "$ver" "$build" "$(uname -m)"
    else
        local pt
        . /etc/os-release
        if [ -r /etc/debian_version ] && grep -qE '^[0-9]+\.[0-9]+' /etc/debian_version; then
            pt=$(cat /etc/debian_version)        # point release, e.g. 13.5
        else
            pt="${VERSION_ID:-}"
        fi
        printf '%s %s (%s) %s' "${NAME:-Linux}" "$pt" "${VERSION_CODENAME:-}" "$(uname -m)"
    fi
}

get_kernel()   { printf '%s %s' "$(uname -s)" "$(uname -r)"; }

get_uptime() {
    local secs
    if [ "$(uname -s)" = Darwin ]; then
        local boot now; boot=$(sysctl -n kern.boottime)      # { sec = 170..., usec = 0 } ...
        boot=${boot#*sec = }; boot=${boot%%,*}; boot=${boot// /}
        now=$(date +%s); secs=$(( now - boot ))
    else
        local up; read -r up _ < /proc/uptime; secs=${up%.*}
    fi
    fmt_uptime "$secs"
}

get_ip() {
    local iface addr
    if [ "$(uname -s)" = Darwin ]; then
        iface=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
        [ -n "$iface" ] || return
        addr=$(ipconfig getifaddr "$iface" 2>/dev/null)
        local mask; mask=$(ifconfig "$iface" 2>/dev/null | awk '/inet /{print $4; exit}')
        [ -n "$addr" ] && printf '%s/%s' "$addr" "$(mask2cidr "$mask")"
    else
        iface=$(ip route show default 2>/dev/null \
                | awk '{for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}')
        [ -n "$iface" ] || return
        ip -o -4 addr show dev "$iface" 2>/dev/null | awk '{print $4; exit}'  # 192.168.1.100/24
    fi
}

get_hostname() { local h; h=$(hostname -s 2>/dev/null || hostname); printf '%s' "${h%%.*}"; }

# --- render ------------------------------------------------------------------

row() { printf '\xe2\x80\xa2 %-8s  %s\n' "$1" "$2"; }    # "• Label    value"

row Computer "$(get_computer)"
row OS       "$(get_os)"
row Kernel   "$(get_kernel)"
row Uptime   "$(get_uptime)"
row IP       "$(get_ip)"
row Hostname "$(get_hostname)"
