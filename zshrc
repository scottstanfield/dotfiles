# Scott Stanfield
# http://git.io/dmz

# Timing startup
# % hyperfine --warmup 2 'zsh -i -c "exit"'
# Time (mean ± σ):      1.613 s ±  0.129 s
#
# removing conda activate & azure cli
# Time (mean ± σ):      1.281 s ±  0.020 s 
#
# After fixing up compdump at line 64!
# Time (mean ± σ):     190.4 ms ±   4.8 ms 
#
# Without any plugins
# Time (mean ± σ):     471.5 ms ±   8.4 ms 

umask 007

# PATH
typeset -U path                 # keep duplicates out of the path
path=(/usr/local/bin $path)     # prepend files I install for system
path+=(~/local/bin ~/bin . ~/.go/bin)
path=(/usr/local/opt/llvm/bin $path)

# GNU specific paths for Mac (requires `brew install coreutils`)
[[ -d /usr/local/opt/coreutils/libexec/gnubin ]] && path=(/usr/local/opt/coreutils/libexec/gnubin $path)
[[ -d /usr/local/opt/coreutils/libexec/gnuman ]] && manpath=(/usr/local/opt/coreutils/libexec/gnuman $MANPATH)

# Use the GNU version of ls/cat on Mac from coreutils

require() { hash "$@" || exit 127; }

# GNU ls colors
# ansi-universal dircolors from https://github.com/seebi/dircolors-solarized 
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

if hash dircolors &> /dev/null; then
    [[ -d ~/dmz/dircolors ]] && eval $(dircolors ~/dmz/dircolors/dircolors.ansi-universal)
fi

# BSD LS colors
export LSCOLORS=exfxcxdxbxegedabagacad


# GNU and BSD (macOS) ls flags aren't compatible
ls --version &>/dev/null
if [ $? -eq 0 ]; then
  lsflags="--color --group-directories-first -F"
else
  lsflags="-GF"
  export CLICOLOR=1
fi



alias ls="ls ${lsflags}"
alias ll="ls ${lsflags} -l"
alias lla="ls ${lsflags} -la"
alias la="ls ${lsflags} -la"
alias lls="ls ${lsflags} -lS"
alias h="history"
alias hg="history | grep -i"
alias @="printenv | grep -i"
alias ,="cd .."
alias m="less"
alias cp="cp -a"
alias pd='pushd'  # symmetry with cd
alias df='df -h'  # human readable
alias t='tmux -2 new-session -A -s "$(hostname)"'		# set variable in .secret
alias ts='tmux -2 -S /var/tmux/campfire new-session -A -s campfire'
alias tj='tmux -2 -S /var/tmux/campfire attach'
alias rg='rg --pretty --smart-case'
alias rgc='rg --no-line-number --color never '              # clean version of rg suitable for piping
#alias ping='prettyping --nolegend'


# Simple default prompt (impure is a better prompt)
PROMPT='%n@%m %3~%(!.#.$)%(?.. [%?]) '

# Speedup tip: https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
	compinit
done
compinit -C

setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses

# MISC
setopt autocd                   # cd to a folder just by typing it's name
setopt extendedglob		        # ls *(.) shows just files; ls *(/) for folders
setopt interactive_comments     # allow # comments in shell; good for copy/paste
unsetopt correct_all            # I don't care for 'suggestions' from ZSH
export BLOCK_SIZE="'1"          # Add commas to file sizes
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete


# BINDKEY
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' '  magic-space


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

compinit -d

for p in $plugins; do
  if [ -f $ZSH/plugins/$p/$p.plugin.zsh ]; then
    source $ZSH/plugins/$p/$p.plugin.zsh
  fi
done


COMPLETION_WAITING_DOTS="true"

###################################################

export LANGUAGE=en_US.UTF-8

# LESS (is more)
export PAGER=less
less_options=(
    --quit-if-one-screen     # If the entire text fits on one screen, just show it and quit. (like cat)
    --no-init                # Do not clear the screen first.
    --ignore-case            # Like "smartcase" in Vim: ignore case unless the search pattern is mixed.
    --chop-long-lines        # Do not automatically wrap long lines.
    --RAW-CONTROL-CHARS      # Allow ANSI colour escapes, but no other escapes.
    --quiet                  # No bell when trying to scroll past the end of the buffer.
    --dumb                   # Do not complain when we are on a dumb terminal.
);
export LESS="${less_options[*]}";
unset less_options;
export LESSCHARSET='utf-8'

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
alias ssh="TERM=xterm-256color ssh -Y"

# mssql-cli telemetry defeat
export MSSQL_CLI_TELEMETRY_OPTOUT="1"

# macOS specific
function man2() {
  man -t $@ | open -f -a "Preview"
}


# Functions
function bak() { cp $1\{,.bak\} }
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



# export r_arch=x86_64
# export CC=$(which clang)
# export CXX=g++
# export LC_ALL="${LANGUAGE}"
# export LC_CTYPE="${LANGUAGE}"


# FuzzyFinder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--ansi --height 40% --extended'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow -g "!{.git,node_modules,env}" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo ' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[builtin]=fg=blue
ZSH_HIGHLIGHT_STYLES[command]=fg=blue
ZSH_HIGHLIGHT_STYLES[alias]=fg=blue
ZSH_HIGHLIGHT_STYLES[function]=fg=blue
ZSH_HIGHLIGHT_STYLES[comment]=fg=yellow	      # comments at end of command (not black)
ZSH_HIGHLIGHT_STYLES[path_prefix]=underline   # incomplete paths are underlined

##
## Programming language specific
##

# R Language (rlang)
export R_LIBS=~/.R/lib

# GO
export GOPATH=~/.go
path+=(~/.go/bin)
[[ -s "~/.gvm/scripts/gvm" ]] && source "~/.gvm/scripts/gvm" && gvm use go1.9 > /dev/null  # || echo "gvm init failed"

# RUST
path+=(~/.cargo/bin)

##
## Python via Anaconda (miniconda)
## Shows current active environment in the left prompt
##

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# if [[ -f $HOME/miniconda3/etc/profile.d/conda.sh ]]; then
# # source $HOME/miniconda3/etc/profile.d/conda.sh  # commented out by conda initialize
#     [[ -z $TMUX ]] || conda deactivate; conda activate
# fi

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
##

if [ -d "$HOME/.nvm" ]; then
    declare -a NODE_GLOBALS
    # declare -a NODE_GLOBALS=($(find $HOME/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' 2>/dev/null | xargs -n1 basename | sort | uniq))
    NODE_GLOBALS+=("node")
    NODE_GLOBALS+=("nvm")

    load_nvm () {
        export NVM_DIR=~/.nvm
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    }

    for cmd in "${NODE_GLOBALS[@]}"; do
        eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
    done
fi


# Move these to .zshrc.scott
[[ -f ~/.$HOME/.zshrc.$USER ]] && source $HOME/.zshrc.$USER

# Put your machine-specific settings here
# ~/.secret is not checked into source control
[[ -f ~/.secret ]] && source ~/.secret


