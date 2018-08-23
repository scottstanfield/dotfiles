# Scott Stanfield
# http://git.io/dmz
#

umask 007

# PATH
typeset -U path                 # keep duplicates out of the path
path=(/usr/local/bin $path)     # prepend files I install for system
path+=(~/bin . ~/.go/bin)

# GNU specific paths for Mac (requires `brew install coreutils`)
path=(/usr/local/opt/coreutils/libexec/gnubin $path)
[[ -d /usr/local/opt/coreutils/libexec/gnuman ]] && manpath=(/usr/local/opt/coreutils/libexec/gnuman $MANPATH)

# Use the GNU version of ls/cat on Mac from coreutils
[[ -d ~/dmz/dircolors ]] && eval $(dircolors ~/dmz/dircolors/dircolors.ansi-universal)

# GNU and BSD (macOS) ls flags aren't compatible
ls --version &>/dev/null
if [ $? -eq 0 ]; then
  lsflags="--color --group-directories-first -F"
else
  lsflags="-GF"
  export CLICOLOR=1
fi


# Aliases
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
alias t='TERM=xterm-256color-italic tmux -2 new-session -A -s $MY_TMUX_SESSION'		# set variable in .secret
alias rg='rg --pretty --smart-case'
alias rgc='rg --no-line-number --color never '              # clean version of rg suitable for piping


# More suitable for .zshenv
PROMPT='%n@%m %3~%(!.#.$)%(?.. [%?]) '

# Tab completion
# autoload -Uz compinit && compinit
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;


setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses

# MISC
setopt autocd                   # cd to a folder just by typing it's name
setopt extendedglob		# ls *(.) shows just files; ls *(/) for folders
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

plugins=(impure colorize hub ripgrep zsh-syntax-highlighting)

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
###################################################
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

# BSD LS colors
export LSCOLORS=exfxcxdxbxegedabagacad

# GNU ls colors
# ansi-universal dircolors from https://github.com/seebi/dircolors-solarized 
# LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
# export LS_COLORS
eval `dircolors $HOME/dmz/plugins/dircolors/dircolors.ansi-light`

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



export r_arch=x86_64
export CC=gcc
export CXX=g++
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"


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
#ZSH_HIGHLIGHT_STYLES[path_prefix]=underline   # incomplete paths are underlined
ZSH_HIGHLIGHT_STYLES[comment]=fg=yellow	      # comments at end of command (not black)

# Put your machine-specific settings here
[[ -f ~/.secret ]] && source ~/.secret

##
## Programming language specific
##
#
# R Language
export R_LIBS=~/.R/lib

# NODE
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use           # Still must type 'nvm use default'
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# GO
export GOPATH=~/.go
path+=(~/.go/bin)
[[ -s "~/.gvm/scripts/gvm" ]] && source "~/.gvm/scripts/gvm" && gvm use go1.9 > /dev/null  # || echo "gvm init failed"

# RUST
path+=(~/.cargo/bin)

# PYTHON
# For the local, global python
export PYTHONPATH="/Users/scott/Library/Python/2.7/bin"
path+=(~/Library/Python/2.7/bin)

# Add a snowman to the left-side prompt if we're in a pipenv subshell

# If using Anaconda, comment out this block below:

if [[ -f ~/miniconda3/etc/profile.d/conda.sh ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh activate
    conda activate intelpy
else
    path+=(~/.local/bin)
    if (( ${+PIPENV_ACTIVE} )); then LEFT_PROMPT_EXTRA="☃ "; fi
    alias pips="[ -e Pipfile ] && pipenv shell || echo 'No Pipfile found. Try: pipenv install'"
fi

# what am I using perl for?
# PATH="/home/scott/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="/home/scott/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="/home/scott/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"/home/scott/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/home/scott/perl5"; export PERL_MM_OPT;

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
#[[ -f /home/scott/.nvm/versions/node/v10.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/scott/.nvm/versions/node/v10.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
