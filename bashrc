export CLICOLOR=1
export LANG="en_US.UTF-8"
export PATH=$PATH:.
export PS1="\h \w \$"

alias ls="ls --color --group-directories-first -F"
alias ll="ls --color --group-directories-first -F -l"
alias ,="cd .."
alias m="less"
alias hg="history | grep -i"
alias t="tmux -2 new-session -A -s hello"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend

which "nvim" &> /dev/null && vic="nvim" || vic="vim"
export EDITOR="nvim"
alias vi="${vic} -o"

# Prompt: host␣path␣[nonzero]␣$ 
RED="$(tput setaf 1)"
GRN="$(tput setaf 2)"
CYN="$(tput setaf 6)"
END="$(tput sgr 0)"
function nonzero_return() { RETVAL=$?; [ $RETVAL -ne 0 ] && echo "[$RETVAL] "; }
export PS1="${GRN}\h ${CYN}\w ${RED}\`nonzero_return\`${END}${GRN}\$ ${END}"

# Non-essential aliases

alias r="R --no-save --quiet"
alias R="R --no-save"
alias cp='cp -a'
alias df='df -h'
alias pd='pushd'
alias la="ls --color --group-directories-first -F -a"
alias lla="ls --color --group-directories-first -F -la"
alias gs="git status"