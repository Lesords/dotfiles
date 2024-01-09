#!/bin/bash

# 返回$1指定的git项目的当前分支(branch)或标签名(tag)
# $1 git项目源码位置,为空获则默认为当前文件夹
function current_branch() {
    local folder="$(pwd)"
    [ -n "$1" ] && folder="$1"

    local isGit=`ls -a $folder | grep '^\.git$'`
    if [ "$isGit" == "" ]; then
        echo "fatal: $folder is not a git repository" && return
    fi

    git -C "$folder" rev-parse --abbrev-ref HEAD | grep -v HEAD || \
    git -C "$folder" describe --exact-match HEAD || \
    git -C "$folder" rev-parse HEAD
}

function init-config() {
    echo "" >> $HOME/.bashrc
    echo "source \"\$HOME/.config/lese/init.sh\"" >> $HOME/.bashrc
    echo "bashrc init successful"

    echo -e "please enter your git username: \c" && read username
    echo -e "please enter your git email: \c" && read email

    if [ -z $username -a -z $email ]; then
        git-init && echo "git-init successful"
    else
        git-init $username $email && echo "git-init $username $email successful"
    fi
}

function count() {
    if [ $# -lt 1 ]; then
        echo "error: miss username parameter" && return
    fi

    w | grep $1 | wc -l
}

function init-proxy() {
    LOCAL_DNS=$(cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")

    if [ $# -eq 1 ]; then
        LOCAL_DNS=$1
    fi

    export https_proxy="$LOCAL_DNS:7890"
    export http_proxy="$LOCAL_DNS:7890"
    echo "init proxy successful"
}

function close-proxy() {
    unset https_proxy
    unset http_proxy
    echo "close proxy successful"
}
