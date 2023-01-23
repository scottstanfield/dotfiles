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

# Profile startup times by adding this to you .zshrc: zmodload zsh/zprof
# Start a new zsh. Then run and inspect: zprof > startup.txt
# zmodload zsh/zprof


typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
is_osx()   { [[ $SHELL_PLATFORM == 'osx' ]]; }
in_path()  { command "$1" >/dev/null 2>/dev/null }

export ZSH=$HOME/dmz
export BLOCK_SIZE="'1"          # Add commas to file sizes
export CLICOLOR=1
export DOCKER_BUILDKIT=1
export EDITOR=vim
export VISUAL=vim
export GOPATH=$HOME/.go
export LANG="en_US.UTF-8"
export PAGER=less

# brew shellinfo >> ~/.zshrc
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history inc_append_history  share_history
setopt histfcntllock  histignorealldups   histreduceblanks histsavenodups
setopt autopushd      chaselinks          pushdignoredups  pushdsilent
setopt NO_caseglob    extendedglob        globdots         globstarshort nullglob numericglobsort
setopt NO_flowcontrol interactivecomments rcquotes
setopt autocd                   # cd to a folder just by typing it's name
setopt interactive_comments     # allow # comments in shell; good for copy/paste

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

# remove gnu stuff or **
# remove .poetry
path=(
    $HOME/bin

    /opt/homebrew/bin
    /opt/homebrew/Cellar/coreutils/**/gnubin
    /opt/homebrew/Cellar/gnu-sed/**/gnubin
    /opt/homebrew/Cellar/gnu-tar/**/libexec/gnubin
    /opt/homebrew/Cellar/grep/**/gnubin

    $HOME/.pyenv/shims
    $HOME/.poetry/bin
    $HOME/.cargo/bin
    $HOME/.local/bin
    $HOME/.go/bin
    $HOME/Library/Python/**/bin

    $HOME/moab/bin
    /usr/local/go/bin

    /usr/local/opt/grep/libexec/gnubin
    /usr/local/opt/make/libexec/gnubin
    /usr/local/opt/findutils/libexec/gnubin
    /usr/local/opt/gawk/libexec/gnubin
    /usr/local/opt/gnu-sed/libexec/gnubin
    /usr/local/opt/gnu-tar/libexec/gnubin
    /usr/local/opt/coreutils/libexec/gnubin

    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /usr/sbin
    /bin
    /sbin

    # Remove this line if you're on WSL2 for Windows
    # This is where the host paths get pulled in
    $path[@]

    .
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


## LS and colors
## Tips: https://gist.github.com/syui/11322769c45f42fad962

# GNU and BSD (macOS) ls flags aren't compatible
ls --version &>/dev/null
if [ $? -eq 0 ]; then
    lsflags="--color --group-directories-first -F"

	# Hide stupid $HOME folders created by macOS from command line
	# chflags hidden Movies Music Pictures Public Applications Library
	lsflags+=" --hide Music --hide Movies --hide Pictures --hide Public --hide Library --hide Applications --hide OneDrive"
else
    lsflags="-GF"
    export CLICOLOR=1
fi


## Aliases
alias ,="cd .."
alias @="printenv | sort | grep -i"
alias @="printenv | sort | grep -i"
alias cp="cp -a"
alias dc="docker-compose"
alias dc='docker-compose'
alias df='df -h'  # human readable
alias dkrr='docker run --rm -it -u1000:1000 -v$(pwd):/work -w /work -e DISPLAY=$DISPLAY'
alias dust='dust -r'
alias grep="grep --color=auto"
alias gs="git status 2>/dev/null"
alias h="history 1"
alias hg="history 1 | grep -i"
alias la="ls ${lsflags} -la"
alias ll="ls ${lsflags} -l --sort=extension"
alias lla="ls ${lsflags} -la"
alias lld="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"
alias lln="ls ${lsflags} -l"
alias lls="ls ${lsflags} -l --sort=size --reverse"
alias llt="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"
alias logs="docker logs control -f"
alias ls="ls ${lsflags}"
alias lt="ls ${lsflags} -l --sort=time --reverse --time-style=long-iso"
alias lx="ls ${lsflags} -Xl"
alias m="less"
alias b="bat --plain"
alias p=python3
alias path='echo $PATH | tr : "\n" | cat -n'
alias pd='pushd'  # symmetry with cd
alias r='R --no-save --no-restore-data --quiet'
alias rg='rg --pretty --smart-case --fixed-strings'
alias rgc='rg --no-line-number --color never '
alias ssh="TERM=xterm-256color ssh"
alias t='tmux -2 new-session -A -s "moab"'

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

export R_LIBS="~/R"

function fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

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

function h() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Automatically ls after you cd
# function chpwd() {
#     emulate -L zsh
#     ls -F
# }

# Simple default prompt
PROMPT='%n@%m %3~%(!.#.$)%(?.. [%?]) '

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
which "nvim" &> /dev/null && _vic="nvim" || _vic="vim"
export EDITOR=${_vic}
alias vi="${_vic} -o"

# zshrc and vimrc aliases to edit these two files
alias zshrc="${_vic} ~/.zshrc"
if [[ $EDITOR  == "nvim" ]]; then
    alias vimrc="nvim ~/.config/nvim/init.vim"
else
    alias vimrc="vim ~/.vimrc"
fi


# Put your user-specific settings here
[[ -f $HOME/.zshrc.$USER ]] && source $HOME/.zshrc.$USER

# Put your machine-specific settings here
[[ -f $HOME/.machine ]] && source $HOME/.machine


export DOCKER_BUILDKIT=1
export HOMEBREW_NO_AUTO_UPDATE=1


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

export NVM_LAZY_LOAD=true
# zinit light lukechilds/zsh-nvm

# | completions | # {{{
zinit ice wait silent blockf; 
zinit snippet PZT::modules/completion/init.zsh
unsetopt correct
unsetopt correct_all
setopt extended_glob
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

# brew install fd bat exa glow fzf
# cargo install exa git-delta

# zinit only installs x86 binaries
# zinit wait"1" lucid from"gh-r" as"null" for \
#     sbin"**/fd"                 @sharkdp/fd      \
#     sbin"**/bat"                @sharkdp/bat     \
#     sbin"exa* -> exa"           ogham/exa        \
#     sbin"glow" bpick"*.tar.gz"  charmbracelet/glow
#
#zi wait'0b' lucid from"gh-r" as"program" for @junegunn/fzf
zi ice wait'0a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
zi ice wait'1a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh
zi wait'0c' lucid pick"fzf-finder.plugin.zsh" light-mode for  @leophys/zsh-plugin-fzf-finder

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

# zinit pack"binary+keys" for fzf
# zinit pack"bgn" for fzf
zinit pack for ls_colors


# | syntax highlighting | <-- needs to be last zinit #
zinit light zdharma-continuum/fast-syntax-highlighting
fast-theme -q default
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path]='fg=cyan'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path-to-dir]='fg=cyan,underline'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}comment]='fg=gray'

# 
function prompt_my_host_icon() {
    p10k segment -i '' -f blue
}

exaflags="--classify --color-scale --bytes --group-directories-first"

if in_path "exa" ; then
    alias ls="exa ${exaflags} "$*" "
    alias ll="exa ${exaflags} --long "
    alias lll="exa ${exaflags} --long --git"
    alias lld="exa ${exaflags} --all --long --sort date"
    alias lle="exa ${exaflags} --all --long --sort extension"
    alias lls="exa ${exaflags} --all --long --sort size"
    alias lla="exa ${exaflags} --all --long --sort size"
fi

export BAT_THEME="gruvbox-dark"
export AWS_DEFAULT_PROFILE=dev-additive
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# True if $1 is an executable in $PATH Works in both {ba,z}sh
function is_bin_in_path {
  if [[ -n $ZSH_VERSION ]]; then
    builtin whence -p "$1" &> /dev/null
  else  # bash:
    builtin type -P "$1" &> /dev/null
  fi
}

##
## Lazy load Anaconda to save startup time
## 

function lazyload_conda {
    if whence -p conda; then
        # Placeholder 'conda' shell function
        conda() {
            # Remove this function, subsequent calls will execute 'conda' directly
            unfunction "$0"

            # Follow softlink, then up two folders for typical location of anaconda
            _conda_prefix=dirname $(dirname $(readlink -f $(whence -p conda)))
            echo "prefix: $_conda_prefix"
            
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
lazyload_conda
