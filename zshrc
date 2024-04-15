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
#   Time (mean ± σ):      92.9 ms ±   0.9 ms    [User: 51.0 ms, System: 38.4 ms]
#   Range (min … max):    91.7 ms …  95.5 ms    31 runs
#
# Benchmark relativity macbook M2 air
#   Benchmark 1: zsh -i  -c "exit"
#  Time (mean ± σ):     340.2 ms ± 214.2 ms    [User: 97.0 ms, System: 77.0 ms]
#  Range (min … max):   211.2 ms … 761.1 ms    12 runs


# Profile .zshrc startup times by uncommenting this line:
# zmodload zsh/zprof
# Then start a new zsh. Then run and inspect: zprof > startup.txt
# Profile startup times by adding this to you .zshrc: zmodload zsh/zprof
# Start a new zsh. Then run and inspect: zprof > startup.txt

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

in_path()  { builtin whence -p "$1" &> /dev/null }

export BLOCK_SIZE="'1"          # Add commas to file sizes
export CLICOLOR=1
export EDITOR=vim
export VISUAL=vim
export LANG="en_US.UTF-8"
export PAGER=less
UNAME=$(uname)      # Darin, Linux
ARCH=$(arch)        # arm64, i386, x86_64

if [[ $UNAME == "Darwin" ]]; then
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

if [[ $UNAME  == "Linux" ]]; then
    echo "linux"
fi

#########
# HISTORY
#########

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY         # Record timestamp in history
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history
setopt HIST_FIND_NO_DUPS        # Do not display a line previously found
setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate
setopt HIST_IGNORE_DUPS         # Dont record an entry that was just recorded again
setopt HIST_IGNORE_SPACE        # Dont record an entry starting with a space
setopt HIST_SAVE_NO_DUPS        # Dont write duplicate entries in the history file
setopt INC_APPEND_HISTORY       # Immediately append to history file
setopt SHARE_HISTORY            # Share history between all sessions:

setopt NO_caseglob    
setopt NO_flowcontrol 
setopt NO_nullglob
setopt autocd                   # cd to a folder just by typing it's name
setopt autopushd      
setopt chaselinks          
setopt extendedglob        
setopt globdots         
setopt globstarshort 
setopt interactive_comments     # allow # comments in shell; good for copy/paste
setopt interactivecomments 
setopt nullglob 
setopt numericglobsort
setopt pushdignoredups  
setopt pushdsilent
setopt rcquotes

ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

# BINDKEY
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^p'    history-search-backward
bindkey '^n'    history-search-forward
bindkey ' '     magic-space


# Press "ESC" to edit command line in vim
export KEYTIMEOUT=1
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '' edit-command-line

# mass mv: zmv -n '(*).(jpg|jpeg)' 'epcot-$1.$2'
autoload zmv

##
## PATH
## macOS assumes GNU core utils installed: 
## brew install coreutils findutils gawk gnu-sed gnu-tar grep makeZZ
##
## To insert GNU binaries before macOS BSD versions, run this to import matching folders:
## :r! find /usr/local/opt -type d -follow -name gnubin -print
## :r! find /opt/homebrew/opt -type d -follow -name gnubin -print
#
## It's slow: just add them all, and remove ones that don't match at end
## Same with gnuman
## :r! find /usr/local/opt -type d -follow -name gnuman -print
## :r! find /opt/homebrew/opt -type d -follow -name gnuman -print
##
## Note: I had /Library/Apple/usr/bin because of /etc/path.d/100-rvictl (REMOVED)
##
## Dangerous to put /usr/local/bin in front of /usr/bin, but yolo 
## https://superuser.com/a/580611
##

# Keep duplicates (Unique) out of these paths
typeset -gU path fpath manpath

# Multiple Homebrews on Apple Silicon
if [[ "$(arch)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [[ "$(arch)" == "i386" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

setopt nullglob

path=(
    $HOME/bin

    # $(brew --prefix llvm)/bin
    $path[@]

    /usr/bin
    /usr/sbin
    /bin
    /sbin

    ~/code/rs/rtfd/bin

    .

    $HOME/.cargo/bin
)

# Now, remove paths that don't exist https://stackoverflow.com/a/9352979
path=($^path(N))

## :r! find /opt/homebrew/opt -type d -follow -name gnuman -print
manpath=(
    /opt/homebrew/opt/libtool/libexec/gnuman
    /opt/homebrew/opt/coreutils/libexec/gnuman
    /opt/homebrew/opt/gnu-tar/libexec/gnuman
    /opt/homebrew/opt/grep/libexec/gnuman
    /opt/homebrew/opt/gawk/libexec/gnuman
    /opt/homebrew/opt/make/libexec/gnuman
    /opt/homebrew/opt/findutils/libexec/gnuman
    /opt/homebrew/opt/gnu-which/libexec/gnuman

    /usr/local/share/man
    /usr/share/man

    $manpath[@]
)
manpath=($^manpath(N))
setopt NO_nullglob
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

## LS and colors
## Tips: https://gist.github.com/syui/11322769c45f42fad962

# GNU and BSD (macOS) ls flags aren't compatible
gls --version &>/dev/null
if [ $? -eq 0 ]; then
    lsflags="--color --group-directories-first -F"

	# Hide stupid $HOME folders created by macOS from command line
	# chflags hidden Movies Music Pictures Public Applications Library
    lsflags+='--ignore-glob "Music|Movies|Pictures|Public|Applications|Creative Cloud Files'
else
    lsflags="-GF"
    export CLICOLOR=1
fi

alias la="ls ${lsflags} -la"
alias ll="gls ${lsflags} -l --sort=extension"
alias lla="ls ${lsflags} -la"
alias lld="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"
alias lln="ls ${lsflags} -l"
alias lls="ls ${lsflags} -l --sort=size --reverse"
alias llt="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"

ezaflags="--color=always --classify --color-scale --bytes --group-directories-first"
ezaflags="--classify --color-scale --bytes --group-directories-first"

# the `ls` replacement "eza"
if in_path "eza" ; then
    function els() { eza --classify --color-scale --bytes --group-directories-first $@ }
    alias ls="eza ${ezaflags} "$*" "
    alias ll="eza ${ezaflags} -l "$*" "
    alias ell="eza ${ezaflags} --long --git"
    alias eld="eza ${ezaflags} --all --long --sort date"
    alias elt="eza ${ezaflags} --all --long --sort date"
    alias ele="eza ${ezaflags} --all --long --sort extension"
    alias elss="eza ${ezaflags} --all --long --sort size"
fi

export EZA_COLORS="\
uu=36:\
gu=37:\
sn=32:\
sb=32:\
da=34:\
ur=34:\
uw=35:\
ux=36:\
ue=36:\
gr=34:\
gw=35:\
gx=36:\
tr=34:\
tw=35:\
tx=36:"

## Aliases
alias ,="cd .."
function @() {
  if [ ! "$#" -gt 0 ]; then
    printenv | sort | less
  else
    printenv | sort | grep -i "$1"
  fi
}
alias cp="cp -a"
alias df='df --human-readable'
alias dkrr='docker run --rm -it -u1000:1000 -v$(pwd):/work -w /work -e DISPLAY=$DISPLAY'
alias dust='dust -r'
alias grep="grep --color=auto"
alias gs="git status 2>/dev/null"
alias h="history 1"
alias hg="history 1 | grep -i"
alias logs="docker logs control -f"
alias m="less"
alias b="bat --plain"
alias path='echo $PATH | tr : "\n" | cat -n'
alias pd='pushd'  # symmetry with cd
alias r="R --no-save --no-restore-data --quiet"
alias rg='rg --pretty --smart-case --fixed-strings'
alias rgc='rg --no-line-number --color never '
alias ssh="TERM=xterm-256color ssh"
alias t='tmux -2 new-session -A -s "moab"'

function anybar { echo -n $1 | nc -4u -w0 localhost ${2:-1738}; }

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

function fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

function jl()      { < $1 jq -C . | less }
function gd()      { git diff --color=always $* | less }
function witch()   { file $(which "$*") }
function gg()      { git commit -m "$*" }
function http      { command http --pretty=all --verbose $@ | less -R; }
function fixzsh    { compaudit | xargs chmod go-w }
#function ff()      { find . -iname "$1*" -print }      # replaced by fzf and ctrl-T
function ht()      { (head $1 && echo "---" && tail $1) | less }
function take()    { mkdir -p $1 && cd $1 }
function cols()    { head -1 $1 | tr , \\n | cat -n | column }		# show CSV header
function zcolors() { for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done | column}
function git3()    { git fetch upstream && git merge upstream/main && git push }

# Automatically ls after you cd
function chpwd() {
    emulate -L zsh
    ls -F
}

###################################################

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

# vi alias points to nvim or vim
which "nvim" &> /dev/null && _vi="nvim" || _vi="vim"
export EDITOR=${_vi}
alias vi="${_vi} -o"

# zshrc and vimrc aliases to edit these two files
alias zshrc="${_vi} ~/.zshrc"
if [[ $EDITOR  == "nvim" ]]; then
    alias vimrc="nvim ~/.config/nvim/init.vim"
else
    alias vimrc="vim ~/.vimrc"
fi


# Put your user-specific settings here
[[ -f $HOME/.zshrc.$USER ]] && source $HOME/.zshrc.$USER

# Put your machine-specific settings here
[[ -f $HOME/.machine ]] && source $HOME/.machine

zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix 

##
## zinit plugin installer
##

case "$OSTYPE" in
  linux*) bpick='*((#s)|/)*(linux|musl)*((#e)|/)*' ;;
  darwin*) bpick='*(macos|darwin)*' ;;
  *) echo 'WARN: unsupported system -- some cli programs might not work' ;;
esac

# ZINIT installer {{{
[[ ! -f ~/.zinit/bin/zinit.zsh ]] && {
    print -P "%F{33}▓▒░ %F{220}Installing zsh %F{33}zinit%F{220} plugin manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ Install failed.%f%b"
}
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# }}}

# export NVM_AUTO_USE=false
# export NVM_LAZY_LOAD=true
# zinit light lukechilds/zsh-nvm

# | completions | # {{{
zinit ice wait silent blockf; 
zinit snippet PZT::modules/completion/init.zsh
unsetopt correct
unsetopt correct_all
setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses

# }}}

zinit load zdharma-continuum/history-search-multi-word
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit fpath -f /opt/homebrew/share/zsh/site-functions
# autoload compinit
# compinit
# zinit compinit

# zinit ice blockf atpull'zinit creinstall -q .'
# zinit light zsh-users/zsh-completions

zinit snippet OMZP::ssh-agent

# This is a weird way of loading 4 git-related repos/scripts; consider removing
zinit light-mode for \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-submods \
    zdharma-continuum/zinit-annex-rust

#zinit ice cargo'!lsd'
zinit light zdharma-continuum/null

# For git command extensions
# zinit as"null" wait"1" lucid for sbin                davidosomething/git-my

# brew install fd bat eza glow fzf
# cargo install eza git-delta

# zinit only installs x86 binaries
# zinit wait"1" lucid from"gh-r" as"null" for \
#     sbin"**/fd"                 @sharkdp/fd      \
#     sbin"**/bat"                @sharkdp/bat     \
#     sbin"glow" bpick"*.tar.gz"  charmbracelet/glow
#
#zi wait'0b' lucid from"gh-r" as"program" for @junegunn/fzf
zi ice wait'0a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
zi ice wait'1a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh
zi wait'0c' lucid pick"fzf-finder.plugin.zsh" light-mode for  @leophys/zsh-plugin-fzf-finder

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

# zinit pack"binary+keys" for fzf
# zinit pack"bgn" for fzf
# zinit pack for ls_colors


# | syntax highlighting | <-- needs to be last zinit #
zinit light zdharma-continuum/fast-syntax-highlighting
fast-theme -q default
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path]='fg=cyan'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path-to-dir]='fg=cyan,underline'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}comment]='fg=gray'


export prompticons=(󰯉 󰊠         ▼         󰆚 󰀘 󱍢 󰦥)

function prompt_my_host_icon() {
	p10k segment -i $prompticons[7] -f 074
}

export BAT_THEME="gruvbox-dark"
export AWS_DEFAULT_PROFILE=dev-additive

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='»'


##
## Lazy load Anaconda to save startup time
## 

function lazyload_conda {
    if whence -p conda &> /dev/null; then
        # Placeholder 'conda' shell function
        conda() {
            # Remove this function, subsequent calls will execute 'conda' directly
            unfunction "$0"

            # Follow softlink, then up two folders for typical location of anaconda
            _conda_prefix=dirname $(dirname $(readlink -f $(whence -p conda)))
            
            ## >>> conda initialize >>>
            # !! Contents within this block are managed by 'conda init' !!
            __conda_setup="$("$_conda_prefix/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
            if [ $? -eq 0 ]; then
                eval "$__conda_setup"
            else
                if [ -f "$_conda_prefix/etc/profile.d/conda.sh" ]; then
                    . "$_conda_prefix/etc/profile.d/conda.sh"
                else
                    export PATH="$_conda_prefix/base/bin:$PATH"
                fi
            fi
            unset __conda_setup
            # <<< conda initialize <<<

            $0 "$@"
        }
    fi
}
# lazyload_conda

# my C flags
# export CFLAGS='-Wall -O3 -include stdio.h --std=c17'
# alias goc="cc -xc - $CFLAGS"

export R_LIBS="~/.rlibs"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

