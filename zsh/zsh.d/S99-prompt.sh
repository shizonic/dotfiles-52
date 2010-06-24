# Left side prompt

export PROMPT="%B%m%b %n%# "
if [[ "$TERM" == "screen" ]]; then
    # Override prompt if running in a screen session
    export PROMPT="%# "
fi

# Right side prompt

function _prompt_git {
    local branch=$(git symbolic-ref HEAD 2>/dev/null|awk '{sub(/^refs\/heads\//, ""); print}')
    if [[ -n $branch ]]; then
        echo " %Ugit:$branch%u"
    fi
}

function _prompt_pwd {
    echo " %B$(print -P "%~"|sed 's/\([^\/]\)[^\/]*\//\1\//g')%b"
}

function _prompt_virtualenv {
    if [[ -n $VIRTUAL_ENV ]]; then
        echo " (py:%U`basename \"$VIRTUAL_ENV\"`%u)"
    fi
}

function precmd {
    # Prompt function need to be executed on every command
    export RPROMPT="$(_prompt_git)$(_prompt_pwd)$(_prompt_virtualenv)"
    
}

# vim:ft=zsh