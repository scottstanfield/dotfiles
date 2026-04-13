export CLICOLOR=1
export LANG="en_US.UTF-8"
export PATH=$PATH:$HOME/.local/bin:.

: ${XDG_CACHE_HOME:=${HOME}/.cache}        # non-essential cached data
: ${XDG_CONFIG_HOME:=${HOME}/.config}      # user-specific portable configuration
: ${XDG_DATA_HOME:=${HOME}/.local/share}   # user-specific data (venvs, nvim swap)
: ${XDG_STATE_HOME:=${HOME}/.local/state}  # persistent app state (logs, history)
export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME

alias path="echo $PATH | tr : "\n" | cat -n"
envprint() {
  if [ "$#" -eq 0 ]; then
    printenv | sort | grep -v COLORS | less
  else
    printenv | sort | grep --invert-match COLORS | grep --ignore-case --color=always "$1"
  fi
}

alias ls="ls --color -F"
alias ll="ls --color -F -l"
alias ,="cd .."
alias m="less"
alias h="history"
alias hg="history | grep -i"
alias t="tmux -2 new-session -A -s hello"
alias pd='pushd'
alias gs="git status"
alias cp="cp -a"

less_options=(
    --chop-long-lines        # -S Do not automatically wrap long lines.
    --ignore-case            # -i Like "smartcase" in Vim: ignore case unless the search pattern is mixed.
    --LONG-PROMPT            # -M most verbose prompt
    --no-init                # -X Do not clear the screen first.
    --quit-if-one-screen     # -F If the entire text fits on one screen, just show it and quit. (like cat)
    --RAW-CONTROL-CHARS      # -R Allow ANSI colour escapes, but no other escapes.
);
export LESS="${less_options[*]}";

shopt -s histappend							# append rather than overwrite history
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000						# save last 100k commands
export HISTFILESIZE=100000					# save last 100k commands

# Prefer nvim over vim
which "nvim" &> /dev/null && vic="nvim" || vic="vim"
export EDITOR="${vic}"
alias vi="${vic} -o"

# Prompt: host␣path␣[nonzero]␣$ 
RED="\e[0;31m"
GRN="\e[0;33m"
CYN="\e[0;36m"
END="\e[0m"
function nonzero_return() { RETVAL=$?; [ $RETVAL -ne 0 ] && echo "[$RETVAL] "; }
export PS1="\h \w \$ "
export PS1="${GRN}\h ${CYN}\w ${RED}\`nonzero_return\`${END}${GRN}\$ ${END}"

