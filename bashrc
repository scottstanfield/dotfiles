export CLICOLOR=1
export LANG="en_US.UTF-8"
export PATH=$PATH:.

alias ls="ls --color --group-directories-first -F"
alias ll="ls --color --group-directories-first -F -l"
alias ,="cd .."
alias m="less"
alias hg="history | grep -i"
alias t="tmux -2 new-session -A -s hello"
alias pd='pushd'
alias gs="git status"


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

# Non-essential aliases
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
