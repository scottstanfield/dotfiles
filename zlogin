# Authors: Sorin Ionescu <sorin.ionescu@gmail.com>

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

in_path()  { command "$1" >/dev/null 2>/dev/null }

# Execute code only if STDERR is bound to a TTY.
if [[ -o INTERACTIVE && -t 2 ]]; then

    if [[ -z "$TMUX" ]]; then
        if test "$(uname -s)" = "Linux"; then
            in_path "splash" && splash
        else
            in_path "darwin-splash" && darwin-splash
        fi
    fi
    true

fi >&2
