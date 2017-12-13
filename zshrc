# Scott Stanfield
# http://git.io/dmz
#

umask 007

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
alias hg="history -1000 | grep -i"
alias ,="cd .."
alias m="less"
alias cp="cp -a"
alias pd='pushd'  # symmetry with cd
alias df='df -h'  # human readable
alias t='tmux new-session -A -s atlantis'

# More suitable for .zshenv
PROMPT='%n@%m %3~%(!.#.$)%(?.. [%?]) '


# Tab completion
autoload -Uz compinit && compinit
setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses

# MISC
setopt autocd                   # cd to a folder just by typing it's name
setopt extendedglob		# ls *(.) shows just files; ls *(/) for folders
setopt interactive_comments     # allow # comments in shell; good for copy/paste
unsetopt correct_all            # I don't care for 'suggestions' from ZSH
export BLOCK_SIZE="'1"          # Add commas to file sizes
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

# PATH
typeset -U path                 # keep duplicates out of the path
path=(/usr/local/bin $path ~/bin . ~/.go/bin)                 # append current directory to path (controversial)

# BINDKEY
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' '  magic-space

# -- end of minimal .zshrc --
#


####################################
# Stripped-down version of oh-my-zsh
####################################
export ZSH=$HOME/dmz

for c in $ZSH/lib/*.zsh; do
  source $c
done

plugins=(impure colorize hub ripgrep)

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

# Using ssh forwarding instead from client

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
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

# GO language needs to know where to put binaries
export GOPATH=~/.go

# Which editor: vi, vim or neovim (nvim)
hash "nvim" &> /dev/null && vic="nvim" || vic="vim"
export EDITOR=${vic}
alias vi="${vic} -p"

if [[ $EDITOR  == "nvim" ]]; then
	alias vimrc="nvim ~/.config/nvim/init.vim"
else
	alias vimrc="vim ~/.vimrc"
fi

# Aliases
alias ag="ag --literal "
alias R="R --no-save"
alias r='R --no-save --quiet'
alias make="make --no-print-directory"
alias grep="grep --color=auto"
alias gpg="gpg2"
alias shs="ssh -Y"    # enable X11 forwarding back to the Mac running XQuartz to display graphs

# Functions
function ff() { find . -iname "$1*" -print }
function ht() { (head $1 && echo "---" && tail $1) | less }
function monitor() { watch --no-title "clear; cat $1" }
function take() { mkdir -p $1 && cd $1 }

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



export CC=gcc
export CXX=g++
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40%'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow -g "!{.git,node_modules,env}" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# My custom highlights
source $HOME/dmz/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo ' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[builtin]=fg=blue
ZSH_HIGHLIGHT_STYLES[command]=fg=blue
ZSH_HIGHLIGHT_STYLES[alias]=fg=blue
ZSH_HIGHLIGHT_STYLES[function]=fg=blue

ZSH_HIGHLIGHT_STYLES[path_prefix]=underline   # incomplete paths are underlined
ZSH_HIGHLIGHT_STYLES[comment]=fg=yellow	      # comments at end of command (not black)

export R_LIBS=~/.R/library

export NVM_DIR="/home/scott/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/scott/.nvm/versions/node/v9.2.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/scott/.nvm/versions/node/v9.2.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/scott/.nvm/versions/node/v9.2.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /home/scott/.nvm/versions/node/v9.2.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
#
# Put your machine-specific settings here
[[ -f ~/.secret ]] && source ~/.secret

