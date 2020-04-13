# Pure
# by Sindre Sorhus
# https://github.com/sindresorhus/pure
# MIT License

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
# terminal codes:
# \e7   => save cursor position
# \e[2A => move cursor 2 lines up
# \e[1G => go to position 1 in terminal
# \e8   => restore cursor position
# \e[K  => clears everything after the cursor on the current line
# \e[2K => clear everything on the current line
#

function prompt_error {
    local B=''
    B="%(?.%F{16}.%F{red}[%?])"
    echo $B
}

function tail_color {
    local B=''
    B="%(?.%F{green}.%F{red})"
    echo $B
}

function prompt_tail {
    local error="×"
    local su="⚡"
    local regular="»"

    # small dot: ·
    # multiplication x: ×
    # large multiplication x: ✖
    # guillemet: »
    # section: §
    # black circle: ●
    # lozenge: ◊
    # implies: ⇒
    # ordered set: ≻
    # bigger greater than: ❯

    local normal="%(!.$su.$regular)"
    local promptchar="%(?.$normal.$error)"

    if [[ `tput cols` -gt 60 ]]; then
        B+=$promptchar
    else
        B+="\n$promptchar"
    fi
    B+="%f"
    echo $B
}


# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
# https://github.com/sindresorhus/pretty-time-zsh
prompt_pure_human_time_to_var() {
    local human=" " total_seconds=$1 var=$2
    local days=$(( total_seconds / 60 / 60 / 24 ))
    local hours=$(( total_seconds / 60 / 60 % 24 ))
    local minutes=$(( total_seconds / 60 % 60 ))
    local seconds=$(( total_seconds % 60 ))
    (( days > 0 )) && human+="${days}d "
    (( hours > 0 )) && human+="${hours}h "
    (( minutes > 0 )) && human+="${minutes}m "
    human+="${seconds}s"

    # store human readable time in variable as specified by caller
    typeset -g "${var}"="${human}"
}

# stores (into prompt_pure_cmd_exec_time) the exec time of the last command if set threshold was exceeded
prompt_pure_check_cmd_exec_time() {
    integer elapsed
    (( elapsed = EPOCHSECONDS - ${prompt_pure_cmd_timestamp:-$EPOCHSECONDS} ))
    prompt_pure_cmd_exec_time=
    (( elapsed > ${PURE_CMD_MAX_EXEC_TIME:=5} )) && {
        prompt_pure_human_time_to_var $elapsed "prompt_pure_cmd_exec_time"
    }
}

prompt_pure_check_git_arrows() {
    # reset git arrows
    prompt_pure_git_arrows=

    # check if there is an upstream configured for this branch
    command git rev-parse --abbrev-ref @'{u}' &>/dev/null || return

    local arrow_status
    # check git left and right arrow_status
    arrow_status="$(command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)"
    # exit if the command failed
    (( !$? )) || return

    # left and right are tab-separated, split on tab and store as array
    arrow_status=(${(ps:\t:)arrow_status})
    local arrows left=${arrow_status[1]} right=${arrow_status[2]}

    (( ${right:-0} > 0 )) && arrows+="${PURE_GIT_DOWN_ARROW:-⇣}"
    (( ${left:-0} > 0 )) && arrows+="${PURE_GIT_UP_ARROW:-⇡}"

    [[ -n $arrows ]] && prompt_pure_git_arrows=" ${arrows}"
}

prompt_pure_set_title() {
    # emacs terminal does not support settings the title
    (( ${+EMACS} )) && return

    # tell the terminal we are setting the title
    print -n '\e]0;'
    # show hostname if connected through ssh
    [[ -n $SSH_CONNECTION ]] && print -Pn '(%m) '
    case $1 in
        expand-prompt)
            print -Pn $2;;
        ignore-escape)
            print -rn $2;;
    esac
    # end set title
    print -n '\a'
}

prompt_pure_preexec() {
    # attempt to detect and prevent prompt_pure_async_git_fetch from interfering with user initiated git or hub fetch
    [[ $2 =~ (git|hub)\ .*(pull|fetch) ]] && async_flush_jobs 'prompt_pure'

    prompt_pure_cmd_timestamp=$EPOCHSECONDS

    # shows the current dir and executed command in the title while a process is active
    prompt_pure_set_title 'ignore-escape' "$PWD:t: $2"
}

prompt_pure_preprompt_render() {
    # store the current prompt_subst setting so that it can be restored later
    local prompt_subst_status=$options[prompt_subst]

    # make sure prompt_subst is unset to prevent parameter expansion in preprompt
    setopt local_options no_prompt_subst

    # check that no command is currently running, the preprompt will otherwise be rendered in the wrong place
    [[ -n ${prompt_pure_cmd_timestamp+x} && "$1" != "precmd" ]] && return

    # set color for git branch/dirty status, change color if dirty checking has been delayed
    local git_color=100
    [[ -n ${prompt_pure_git_last_dirty_check_timestamp+x} ]] && git_color=red
    # Keeping this here for bold color reference
    # PROMPT='$green%m %{$fg_bold[green]%}%4~%{$fg_bold[red]%}%(?.. [%?]) $(prompt_tail) '

    ####################
    # LEFT-SIDE PROMPT
    ####################
    local name_machine='%F{white}%n@%m%f'
    if [[ $(whoami) == "scott" ]]; then
        name_machine='%F{blue}%m%f'
    else
        name_machine='%F{blue}%n@%m%f'
    fi

    local left=""
    # only show the trailing two folders
    # local pathdetails="%F{blue}%2~%f"
    
    local pathdetails="%F{black}%3~%f"
    # [[ "$SSH_CONNECTION" != '' ]] && name_machine=' %F{242}%n@%m%f'       # if on SSH, use a different prompt
    [[ $UID -eq 0 ]] && name_machine=' %F{white}%n%f%F{242}@%m%f'           # if root

    left+="${LEFT_PROMPT_EXTRA}"             # set in .zshrc or a pipenv command to indicate subshell
    left+="${name_machine} "                 # username@hostname
    left+="${pathdetails} "                  # ~/foo/bar
    left+="$(tail_color)$(prompt_tail)%f "   # turn tail red if last exited with an error code (shown on right)

    ####################
    # RIGHT-SIDE PROMPT
    ####################

    # command execution time (if any)
    local right="%F{yellow}${prompt_pure_cmd_exec_time}%f"

    # repo name
    right+="%F{$git_color}${vcs_info_msg_0_}${prompt_pure_git_dirty}%f"

    # arrows for push / pull
    right+="%F{cyan}${prompt_pure_git_arrows}%f"

    # make sure prompt_pure_last_preprompt is a global array
    typeset -g -a prompt_pure_last_preprompt

    PROMPT="$left"
    RPROMPT="$(prompt_error)$right"

    # if executing through precmd, do not perform fancy terminal editing
    if [[ "$1" != "precmd" ]]; then
        # only redraw if the expanded preprompt has changed
        [[ "${prompt_pure_last_preprompt[2]}" != "${(S%%)right}" ]] || return

        # redraw prompt (also resets cursor position)
        zle && zle .reset-prompt
    fi

    # store both unexpanded and expanded preprompt for comparison
    prompt_pure_last_preprompt=("$right" "${(S%%)right}")
}

prompt_pure_precmd() {
    # check exec time and store it in a variable
    prompt_pure_check_cmd_exec_time

    # by making sure that prompt_pure_cmd_timestamp is defined here the async functions
    # are prevented from interfering with the initial preprompt rendering
    prompt_pure_cmd_timestamp=

    # check for git arrows
    prompt_pure_check_git_arrows

    # shows the full path in the title
    prompt_pure_set_title 'expand-prompt' '%~'

    # get vcs info
    vcs_info

    # preform async git dirty check and fetch
    prompt_pure_async_tasks

    # print the preprompt
    prompt_pure_preprompt_render "precmd"

    # remove the prompt_pure_cmd_timestamp, indicating that precmd has completed
    unset prompt_pure_cmd_timestamp
}

# fastest possible way to check if repo is dirty
prompt_pure_async_git_dirty() {
    local untracked_dirty=$1; shift

    # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
    builtin cd -q "$*"

    if [[ "$untracked_dirty" == "0" ]]; then
        command git diff --no-ext-diff --quiet --exit-code
    else
        test -z "$(command git status --porcelain --ignore-submodules -unormal)"
    fi

    (( $? )) && echo "*"
}

prompt_pure_async_git_fetch() {
    # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
    builtin cd -q "$*"

    # set GIT_TERMINAL_PROMPT=0 to disable auth prompting for git fetch (git 2.3+)
    GIT_TERMINAL_PROMPT=0 command git -c gc.auto=0 fetch
}

prompt_pure_async_tasks() {
    # initialize async worker
    ((!${prompt_pure_async_init:-0})) && {
        async_start_worker "prompt_pure" -u -n
        async_register_callback "prompt_pure" prompt_pure_async_callback
        prompt_pure_async_init=1
    }

    # store working_tree without the "x" prefix
    local working_tree="${vcs_info_msg_1_#x}"

    # check if the working tree changed (prompt_pure_current_working_tree is prefixed by "x")
    if [[ ${prompt_pure_current_working_tree#x} != $working_tree ]]; then
        # stop any running async jobs
        async_flush_jobs "prompt_pure"

        # reset git preprompt variables, switching working tree
        unset prompt_pure_git_dirty
        unset prompt_pure_git_last_dirty_check_timestamp

        # set the new working tree and prefix with "x" to prevent the creation of a named path by AUTO_NAME_DIRS
        prompt_pure_current_working_tree="x${working_tree}"
    fi

    # only perform tasks inside git working tree
    [[ -n $working_tree ]] || return

    # do not preform git fetch if it is disabled or working_tree == HOME
    if (( ${PURE_GIT_PULL:-1} )) && [[ $working_tree != $HOME ]]; then
        # tell worker to do a git fetch
        async_job "prompt_pure" prompt_pure_async_git_fetch "${working_tree}"
    fi

    # if dirty checking is sufficiently fast, tell worker to check it again, or wait for timeout
    integer time_since_last_dirty_check=$(( EPOCHSECONDS - ${prompt_pure_git_last_dirty_check_timestamp:-0} ))
    if (( time_since_last_dirty_check > ${PURE_GIT_DELAY_DIRTY_CHECK:-1800} )); then
        unset prompt_pure_git_last_dirty_check_timestamp
        # check check if there is anything to pull
        async_job "prompt_pure" prompt_pure_async_git_dirty "${PURE_GIT_UNTRACKED_DIRTY:-1}" "${working_tree}"
    fi
}

prompt_pure_async_callback() {
    local job=$1
    local output=$3
    local exec_time=$4

    case "${job}" in
        prompt_pure_async_git_dirty)
            prompt_pure_git_dirty=$output
            prompt_pure_preprompt_render

            # When prompt_pure_git_last_dirty_check_timestamp is set, the git info is displayed in a different color.
            # To distinguish between a "fresh" and a "cached" result, the preprompt is rendered before setting this
            # variable. Thus, only upon next rendering of the preprompt will the result appear in a different color.
            (( $exec_time > 2 )) && prompt_pure_git_last_dirty_check_timestamp=$EPOCHSECONDS
            ;;
        prompt_pure_async_git_fetch)
            prompt_pure_check_git_arrows
            prompt_pure_preprompt_render
            ;;
    esac
}

prompt_pure_setup() {
    # prevent percentage showing up
    # if output doesn't end with a newline
    export PROMPT_EOL_MARK=''

    prompt_opts=(subst percent cr)

    zmodload zsh/datetime
    zmodload zsh/zle
    zmodload zsh/parameter

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info
    autoload -Uz async && async

    add-zsh-hook precmd prompt_pure_precmd
    add-zsh-hook preexec prompt_pure_preexec

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' use-simple true
    # only export two msg variables from vcs_info
    zstyle ':vcs_info:*' max-exports 2
    # vcs_info_msg_0_ = ' %b' (for branch)
    # vcs_info_msg_1_ = 'x%R' git top level (%R), x-prefix prevents creation of a named path (AUTO_NAME_DIRS)
    zstyle ':vcs_info:git*' formats ' %b' 'x%R'
    zstyle ':vcs_info:git*' actionformats ' %b|%a' 'x%R'

    # create prompt
    prompt_pure_preprompt_render 'precmd'
}

prompt_pure_setup "$@"


