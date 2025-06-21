[ -r ~/.bashrc ] && . ~/.bashrc

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/Users/sstanfield/.juliaup/bin:*)
        ;;

    *)
        export PATH=/Users/sstanfield/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
. "$HOME/.cargo/env"
