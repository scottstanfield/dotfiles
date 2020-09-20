# Scott Stanfield
# http://git.io/dmz/

# Timing startup
# % hyperfine --warmup 2 'zsh -i -c "exit"'

# Superfast as of Jun 20, 2020
# Benchmark #1: zsh -i -c "exit"
#   Time (mean ± σ):     137.3 ms ±   4.5 ms    [User: 61.5 ms, System: 71.6 ms]
#   Range (min … max):   130.8 ms … 152.2 ms    19 runs

# Profile startup times by adding this to you .zshrc: zmodload zsh/zprof
# Start a new zsh. Then run and inspect: zprof > startup.txt

is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
is_osx() { [[ $SHELL_PLATFORM == 'osx' ]]; }

export LANG=en_US.UTF-8
export SHELL=${SHELL:-`which zsh`} # For Clear Linux or Docker (not sure which)
export VISUAL=nvim
export PAGER=less

##
## PATH
## macOS assumes GNU core utils installed: 
## brew install coreutils findutils gawk gnu-sed gnu-tar grep makeZZ
##
## To insert GNU binaries before macOS BSD versions, run this to import matching folders:
## :r! find /usr/local/opt -type d -follow -name gnubin -print
## It's slow: just add them all, and remove ones that don't match at end
## Same with gnuman
## :r! find /usr/local/opt -type d -follow -name gnuman -print
##
## For zsh (N-/) ==> https://stackoverflow.com/a/9352979
## Note: I had /Library/Apple/usr/bin because of /etc/path.d/100-rvictl (REMOVED)
##
## Dangerous to put /usr/local/bin in front of /usr/bin, but yolo 
## https://superuser.com/a/580611
##

# Keep duplicates (Unique) out of these paths
typeset -gU path fpath manpath

path=(
    $HOME/bin
    $HOME/.local/bin

    /usr/local/opt/grep/libexec/gnubin
    /usr/local/opt/make/libexec/gnubin
    /usr/local/opt/findutils/libexec/gnubin
    /usr/local/opt/gawk/libexec/gnubin
    /usr/local/opt/gnu-sed/libexec/gnubin
    /usr/local/opt/gnu-tar/libexec/gnubin
    /usr/local/opt/coreutils/libexec/gnubin

    /usr/local/opt/libiconv/bin     # iconv utility
    /usr/local/opt/llvm/bin         # llvm

    $HOME/.cargo/bin
    $HOME/.go/bin

    /usr/local/bin
    /usr/bin
    /usr/sbin
    /bin
    /sbin

    $path[@]
)

# Now, remove paths that don't exist...
path=($^path(N))

manpath=(
    /usr/local/opt/findutils/libexec/gnuman
    /usr/local/opt/gnu-sed/libexec/gnuman
    /usr/local/opt/make/libexec/gnuman
    /usr/local/opt/gawk/libexec/gnuman
    /usr/local/opt/grep/libexec/gnuman
    /usr/local/opt/gnu-tar/libexec/gnuman
    /usr/local/opt/coreutils/libexec/gnuman

    /usr/local/share/man
    /usr/share/man

    $manpath[@]
)
manpath=($^manpath(N))

## end of path


##
## LS and colors
## 

## Tips: https://gist.github.com/syui/11322769c45f42fad962

# Load GNU colors for GNU version of ls
[[ -d ~/dmz/dircolors ]] && eval $(dircolors ~/dmz/dircolors/dircolors.256dark)

# BSD LS colors as backup
export LSCOLORS=exfxcxdxbxegedabagacad

# GNU and BSD (macOS) ls flags aren't compatible
ls --version &>/dev/null
if [ $? -eq 0 ]; then
    lsflags="--color --group-directories-first -F"
else
    lsflags="-GF"
    export CLICOLOR=1
fi


# Aliases
alias path='echo $PATH | tr : "\n" | cat -n'
alias ls="ls ${lsflags}"
alias ll="ls ${lsflags} -l --sort=extension"
alias lln="ls ${lsflags} -l"
alias lls="ls ${lsflags} -l --sort=size --reverse"
alias llt="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"
alias lld="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"
alias lt="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"
alias lx="ls ${lsflags} -Xl"
alias lla="ls ${lsflags} -la"
alias la="ls ${lsflags} -la"
alias h="history"
alias hg="history | grep -i"
alias @="printenv | sort | grep -i"
alias ,="cd .."
alias m="less"
alias cp="cp -a"
alias pd='pushd'  # symmetry with cd
alias df='df -h'  # human readable
alias t='tmux -2 new-session -A -s "bonsai"'		# set variable in .secret
alias ts='tmux -2 -S /var/tmux/campfire new-session -A -s bonsai'
alias tj='tmux -2 -S /var/tmux/campfire attach'
alias rg='rg --pretty --smart-case'
alias rgc='rg --no-line-number --color never '              # clean version of rg suitable for piping
alias dc='docker-compose'


# Simple default prompt (impure is a better prompt)
PROMPT='%n@%m %3~%(!.#.$)%(?.. [%?]) '

setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses

# MISC
setopt autocd                   # cd to a folder just by typing it's name
setopt interactive_comments     # allow # comments in shell; good for copy/paste
setopt extendedglob
unsetopt correct_all            # I don't care for 'suggestions' from ZSH
export BLOCK_SIZE="'1"          # Add commas to file sizes
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

# BINDKEY
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' '  magic-space

# ctrl-e will edit command line in $EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

####################################
# Stripped-down version of oh-my-zsh
####################################
export ZSH=$HOME/dmz

for c in $ZSH/lib/*.zsh; do
    source $c
done

plugins=(impure ripgrep zsh-syntax-highlighting)

for p in $plugins; do
    fpath=($ZSH/plugins/$p $fpath)
done

for p in $plugins; do
    if [ -f $ZSH/plugins/$p/$p.plugin.zsh ]; then
        source $ZSH/plugins/$p/$p.plugin.zsh
    fi
done

COMPLETION_WAITING_DOTS="true"

# startup speedup tip: https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
() {
setopt local_options extendedglob
if [[ -n $HOME/.zcompdump(#qN.m1) ]]; then
    echo "compiling compinit..."
    compinit
    touch $HOME/.zcompdump
else
    compinit -C         # happy path, skip compile
fi
}



###################################################

# LESS (is more)
less_options=(
    --quit-if-one-screen     # -F If the entire text fits on one screen, just show it and quit. (like cat)
    --no-init                # -X Do not clear the screen first.
    --ignore-case            # -i Like "smartcase" in Vim: ignore case unless the search pattern is mixed.
    --chop-long-lines        # -S Do not automatically wrap long lines.
    --RAW-CONTROL-CHARS      # -R Allow ANSI colour escapes, but no other escapes.
    --quiet                  # -q No bell when trying to scroll past the end of the buffer.
    --dumb                   # -d Do not complain when we are on a dumb terminal.
    --LONG-PROMPT            # -M most verbose prompt
    );
    export LESS="${less_options[*]}";
    unset less_options;

# http://joepvd.github.io/less-a-love-story.html
# export LESSCHARSET='utf-8'
# export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
# export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
# export LESS_TERMCAP_me=$'\e[0m'           # end mode
# export LESS_TERMCAP_so=$'\e[38;5;070m'    # begin standout (info box, search)
# export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
# export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline
# export LESS_TERMCAP_ue=$'\e[0m'           # end underline
# export MAN_KEEP_FORMATTING=1

# Which editor: vi, vim or neovim (nvim)
which "nvim" &> /dev/null && vic="nvim" || vic="vim"
export EDITOR=${vic}
alias vi="${vic} -o"
alias zshrc="${vic} ~/.zshrc"

if [[ $EDITOR  == "nvim" ]]; then
    alias vimrc="nvim ~/.config/nvim/init.vim"
else
    alias vimrc="vim ~/.vimrc"
fi
alias v="/usr/bin/vi"

# Aliases
alias ag="ag --literal "
alias R="R --no-save"
alias r='R --no-save --quiet'
alias make="make --no-print-directory"
alias grep="grep --color=auto"
alias shs="ssh -Y"    # enable X11 forwarding back to the Mac running XQuartz to display graphs
#alias ssh="TERM=xterm-256color ssh -Y"
alias ssh="TERM=xterm-256color ssh"

# macOS specific
function man2() {
    man -t $@ | open -f -a "Preview"
}


# Functions
function ff() { find . -iname "$1*" -print }
function ht() { (head $1 && echo "---" && tail $1) | less }
function monitor() { watch --no-title "clear; cat $1" }
function take() { mkdir -p $1 && cd $1 }
function cols() { head -1 $1 | tr , \\n | cat -n | column }		# show CSV header
function zcolors() { for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done | column}

# Automatically ls after you cd
function chpwd() {
    emulate -L zsh
    ls
}
#
# GIT
# Do this: git config --global url.ssh://git@github.com/.insteadOf https://github.com
hubpath=$(which hub)
if (( $+commands[hub] )); then
    alias git=$hubpath
fi

# Use diff-so-fancy if found in path
hash "diff-so-fancy" &> /dev/null && alias gd="git dsf" || alias gd="git diff"

alias gs="git status 2>/dev/null"
function gc() { git clone ssh://git@github.com/"$*" }
function gg() { git commit -m "$*" }


# FuzzyFinder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--ansi --height 40% --extended'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow -g "!{.git,node_modules,env}" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo ' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[builtin]=fg=blue
ZSH_HIGHLIGHT_STYLES[command]=fg=blue
ZSH_HIGHLIGHT_STYLES[alias]=fg=blue
ZSH_HIGHLIGHT_STYLES[function]=fg=blue
ZSH_HIGHLIGHT_STYLES[comment]=fg=yellow	      # comments at end of command (not black)
ZSH_HIGHLIGHT_STYLES[path_prefix]=underline   # incomplete paths are underlined

##
## Programming language specific
##

# R Language
export R_LIBS=~/.R/lib
export R_LIBS="/usr/local/Cellar/r/4.0.0_1/lib/R/library"

##
## Anaconda: test for conda and load it lazily
## curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o /tmp/conda.sh
## bash /tmp/conda.sh -b -p $HOME/miniconda
##

if [ -d "$HOME/miniconda" ]; then
    declare -a python_globals=("python")
    python_globals+=("python3")
    python_globals+=("conda")

    load_conda() {
        cs="$("$HOME/miniconda/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
        eval "$cs"
    }

    for cmd in "${python_globals[@]}"; do
        eval "${cmd}(){ unset -f ${python_globals}; load_conda; ${cmd} \$@ }"
    done
fi

function conda_indicator {
    if [[ -z $CONDA_PROMPT_MODIFIER ]] then
        psvar[1]=''
    elif [[ $CONDA_DEFAULT_ENV == "base" ]] then
        psvar[1]=''
    else
        psvar[1]='('${CONDA_DEFAULT_ENV##*/}')'
    fi
}
add-zsh-hook precmd conda_indicator
LEFT_PROMPT_EXTRA="%(1V.%1v .)"

##
## JAVA
##
## [[ -f /usr/libexec/java_home ]] && JAVA_HOME=$(/usr/libexec/java_home)

##
## NODE: test for NVM and load it lazily
## consider replacing the below with https://github.com/lukechilds/zsh-nvm
##

if [ -d "$HOME/.nvm/versions/node" ]; then
    declare -a NODE_GLOBALS=($(find $HOME/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' 2>/dev/null | xargs -n1 basename | sort | uniq))
    NODE_GLOBALS+=("node")
    NODE_GLOBALS+=("nvm")

    load_nvm () {
        export NVM_DIR=$HOME/.nvm
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    }

    for cmd in "${NODE_GLOBALS[@]}"; do
        eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
    done
fi

# Put your machine-specific settings here
[[ -f $HOME/.zshrc.$USER ]] && source $HOME/.zshrc.$USER

# Put your machine-specific settings here
[[ -f $HOME/.secret ]] && source $HOME/.secret


export DOCKER_BUILDKIT=1

export LDFLAGS="-L/usr/local/opt/libiconv/lib"
export CPPFLAGS="-I/usr/local/opt/libiconv/include"

export HOMEBREW_NO_AUTO_UPDATE=1
