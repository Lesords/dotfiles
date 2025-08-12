#!/bin/bash

export TERM=xterm-256color

get_git_path() {
    pwd="$PWD"
    while [ "$pwd" != "/" ]; do
        # echo "current pwd: $pwd"
        isGit=`ls -a "$pwd" | grep -E '^\.git/?$'`
        if [ "$isGit" != "" ]; then
            echo $pwd && break
        fi
        pwd=`dirname "$pwd"`
    done
}

git_branch() {
    local isGit=$(get_git_path)
    if [ "$isGit" != "" ]; then
        git_owner=`ls -al $isGit | grep -E '\.git/?$' | awk '{print $3}'`
        current_owner=`whoami`
        [ "$git_owner" != "$current_owner" ] && return

        if [ "$(git branch 2>/dev/null)" == "" ]; then echo " (NULL)" && return; fi
        local branch=`git rev-parse --abbrev-ref HEAD | grep -v HEAD || \
        git describe --exact-match HEAD 2> /dev/null || \
        git rev-parse HEAD`
        echo " ($branch)"
    fi
}

BLUE='\033[36m'
PURPLE='\033[35m'
WHITE='\033[37m'
YELLOW='\033[33m'
PROMPT_COMMAND='echo'

if [ "$MSYSTEM" ]; then
    PS1='${debian_chroot:+($debian_chroot)}'"PC $BLUE\w$WHITE"'`__git_ps1`\n$ '
else
    PS1='${debian_chroot:+($debian_chroot)}'"$BLUE\u$WHITE@$YELLOW\h $BLUE\w$WHITE"'`git_branch`\n> '
fi

# ranger prompt
[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(in ranger) '

# vifm prompt
[ -n "$MYVIFMRC" ] && PS1="$PS1"'(in vifm) '
