# Scott Stanfield
# http://git.io/dmz/

# Timing startup
# % hyperfine --warmup 2 'zsh -i -c "exit"'

# Superfast as of Jun 20, 2020
# Benchmark 16" MacBook Pro #1: zsh -i -c "exit"
#   Time (mean ± σ):     137.3 ms ±   4.5 ms    [User: 61.5 ms, System: 71.6 ms]
#   Range (min … max):   130.8 ms … 152.2 ms    19 runs
#
# Benchmark iMacPro 2019
#  Time (mean ± σ):      92.9 ms ±   0.9 ms    [User: 51.0 ms, System: 38.4 ms]
#  Range (min … max):    91.7 ms …  95.5 ms    31 runs

# Profile startup times by adding this to you .zshrc: zmodload zsh/zprof
# Start a new zsh. Then run and inspect: zprof > startup.txt

# TODO: Workaround for /usr/local/share/zsh made group/world writeable
ZSH_DISABLE_COMPFIX=true
# compaudit | xargs chmod go-w

#typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
is_osx() { [[ $SHELL_PLATFORM == 'osx' ]]; }

export LANG=en_US.UTF-8
export SHELL=${SHELL:-`which zsh`} # For Clear Linux or Docker (not sure which)
export VISUAL=nvim
export PAGER=less
#export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.zsh}"

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

#lsflags+=" --hide [A-Z]* "
# Hide stupid $HOME folders created by macOS from command line
# chflags hidden Movies Music Pictures Public Applications Library
lsflags+=" --hide Music --hide Movies --hide Pictures --hide Public --hide Library --hide Applications "

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
#alias h="history"
alias hg="history | grep -i"
alias @="printenv | sort | grep -i"
alias ,="cd .."
alias m="less"
alias cp="cp -a"
alias pd='pushd'  # symmetry with cd
alias df='df -h'  # human readable
alias t='tmux -2 new-session -A -s "moab"'		# set variable in .secret
alias rg='rg --pretty --smart-case'
alias rgc='rg --no-line-number --color never '              # clean version of rg suitable for piping
alias dc='docker-compose'


# Simple default prompt (impure is a better prompt)
PROMPT='%n@%m %3~%(!.#.$)%(?.. [%?]) '

# MISC
setopt autocd                   # cd to a folder just by typing it's name
setopt interactive_comments     # allow # comments in shell; good for copy/paste
export BLOCK_SIZE="'1"          # Add commas to file sizes
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

# Options
setopt autocd autopushd chaselinks pushdignoredups pushdsilent
setopt NO_caseglob extendedglob globdots globstarshort nullglob numericglobsort
setopt histfcntllock histignorealldups histreduceblanks histsavenodups sharehistory
setopt NO_flowcontrol interactivecomments rcquotes

# BINDKEY
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' '  magic-space

# ctrl-e will edit command line in $EDITOR
# autoload -Uz endit-command-line
# zle -N edit-command-line
# bindkey "^i" edit-command-line

export ZSH=$HOME/dmz

COMPLETION_WAITING_DOTS="true"


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
alias R="R --no-save"
alias r='R --no-save --quiet'
alias make="make --no-print-directory"
alias grep="grep --color=auto"
alias shs="ssh -Y"    # enable X11 forwarding back to the Mac running XQuartz to display graphs
#alias ssh="TERM=xterm-256color ssh -Y"
alias ssh="TERM=xterm-256color ssh"

# Functions
function ff() { find . -iname "$1*" -print }
function ht() { (head $1 && echo "---" && tail $1) | less }
function monitor() { watch --no-title "clear; cat $1" }
function take() { mkdir -p $1 && cd $1 }
function cols() { head -1 $1 | tr , \\n | cat -n | column }		# show CSV header
function zcolors() { for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done | column}

function h() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}


# Automatically ls after you cd
function chpwd() {
    emulate -L zsh
    ls
}

# Use diff-so-fancy if found in path
hash "diff-so-fancy" &> /dev/null && alias gd="git dsf" || alias gd="git diff"

alias gs="git status 2>/dev/null"
function gc() { git clone ssh://git@github.com/"$*" }
function gg() { git commit -m "$*" }




##
## Programming language specific
##

# R Language
export R_LIBS=~/.R/lib
export R_LIBS="/usr/local/Cellar/r/4.0.0_1/lib/R/library"

##
## NODE: test for NVM and load it lazily
## consider replacing the below with https://github.com/lukechilds/zsh-nvm
##

# if [ -d "$HOME/.nvm/versions/node" ]; then
#     declare -a NODE_GLOBALS=($(find $HOME/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' 2>/dev/null | xargs -n1 basename | sort | uniq))
#     NODE_GLOBALS+=("node")
#     NODE_GLOBALS+=("nvm")

#     load_nvm () {
#         export NVM_DIR=$HOME/.nvm
#         [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
#     }

#     for cmd in "${NODE_GLOBALS[@]}"; do
#         eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
#     done
# fi

# Put your machine-specific settings here
[[ -f $HOME/.zshrc.$USER ]] && source $HOME/.zshrc.$USER

# Put your machine-specific settings here
[[ -f $HOME/.secret ]] && source $HOME/.secret


export DOCKER_BUILDKIT=1
export LDFLAGS="-L/usr/local/opt/libiconv/lib"
export CPPFLAGS="-I/usr/local/opt/libiconv/include"
export HOMEBREW_NO_AUTO_UPDATE=1


# FuzzyFinder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--ansi --height 40% --extended'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow -g "!{.git,node_modules,env}" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# ZSH_HIGHLIGHT_STYLES[comment]=fg=yellow	      # comments at end of command (not black)
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
# ZSH_HIGHLIGHT_PATTERNS+=('sudo ' 'fg=white,bold,bg=red')
# ZSH_HIGHLIGHT_STYLES[path]='none'
# ZSH_HIGHLIGHT_STYLES[builtin]=fg=blue
# ZSH_HIGHLIGHT_STYLES[command]=fg=blue
# ZSH_HIGHLIGHT_STYLES[alias]=fg=blue
# ZSH_HIGHLIGHT_STYLES[function]=fg=blue
# ZSH_HIGHLIGHT_STYLES[path_prefix]=underline   # incomplete paths are underlined



# Zinit installer {{{
[[ ! -f ~/.zinit/bin/zinit.zsh ]] && {
    command mkdir -p ~/.zinit
    command git clone --depth=1 https://github.com/zdharma/zinit ~/.zinit/bin
}
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# }}}

export NVM_LAZY_LOAD=true
zinit light lukechilds/zsh-nvm

# | completions | # {{{
zinit ice wait silent blockf; 
zinit snippet PZT::modules/completion/init.zsh
unsetopt correct
unsetopt correct_all
setopt extended_glob
setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses

# }}}

zinit light chriskempson/base16-shell
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
zinit light b4b4r07/httpstat

zinit ice blockf
zinit light zsh-users/zsh-completions
#zinit light zsh-users/zsh-autosuggestions           # ghosts the remainder of command

# | history | #

# This is a weird way of loading 4 git-related repos/scripts; consider removing
zinit light-mode for \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-patch-dl

zinit pack"binary+keys" for fzf

zinit as"null" wait"3" lucid for \
    sbin Fakerr/git-recall \
    sbin paulirish/git-open \
    sbin davidosomething/git-my \
    sbin"bin/git-dsf;bin/diff-so-fancy" zdharma/zsh-diff-so-fancy

# | syntax highlighting | <-- needs to be last zinit #
zinit light zdharma/fast-syntax-highlighting
fast-theme -q default
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path]='fg=cyan'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path-to-dir]='fg=cyan,underline'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}comment]='fg=gray'

# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

