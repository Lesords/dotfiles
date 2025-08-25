#!/bin/bash

# 返回$1指定的git项目的当前分支(branch)或标签名(tag)
# $1 git项目源码位置,为空获则默认为当前文件夹
function current_branch() {
    local folder="$(pwd)"
    [ -n "$1" ] && folder="$1"

    local isGit=`ls -a $folder | grep -E '^\.git/?$'`
    if [ "$isGit" == "" ]; then
        echo "fatal: $folder is not a git repository" && return
    fi

    git -C "$folder" rev-parse --abbrev-ref HEAD | grep -v HEAD || \
    git -C "$folder" describe --exact-match HEAD || \
    git -C "$folder" rev-parse HEAD
}

function update-config() {
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

    echo "$(w | grep $1 | wc -l), $(who | grep $1 | wc -l)"
}

function init-proxy() {
    HTTP_HEADER=""
    LOCAL_PORT=7890
    LOCAL_DNS=$([ -f /etc/resolv.conf ] && cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")

    while [ $# -gt 0 ]; do
        case "$1" in
            -p)
                shift
                LOCAL_PORT=$1
                ;;
            -h)
                HTTP_HEADER="http://"
                ;;
            *)
                LOCAL_DNS=$1
                ;;
        esac
        shift
    done

    export https_proxy="$HTTP_HEADER$LOCAL_DNS:$LOCAL_PORT"
    export http_proxy="$HTTP_HEADER$LOCAL_DNS:$LOCAL_PORT"
    echo "init proxy successful"
    echo "https_proxy=$https_proxy"
    echo "http_proxy=$http_proxy"
}

function close-proxy() {
    unset https_proxy
    unset http_proxy
    echo "close proxy successful"
}

function modify() {
    vim -d $1 $HOME/$1
}

function mkcd() {
    mkdir $1
    cd $1
}

function hexof() {
    hexdump -C $1 | less
}

function rgl() {
    rg -p "$@" | slow
}

function rgd() {
    rg --json "$@" | delta --no-gitconfig --hyperlinks --tabs 0
}

function del-self() {
    folder_name=$(basename "$PWD")
    cd .. && rm -rf "$folder_name"
}

function show-url() {
    urls=$(git remote -v | awk '{print $2}' | uniq | cut -d ':' -f 2)
    for url in $urls;
    do
        if [[ $url == //* ]]; then
            echo "https:$url"
        else
            echo "https://github.com/$url"
        fi
    done
}

function gen-clang-config() {
    CONFIG_FILE=.clang-format
    [ "$1" ] && CONFIG_FILE=$1

    if type clang-format >/dev/null 2>&1; then
        clang-format -style=llvm --dump-config > $CONFIG_FILE
        [ $? -eq 0 ] && echo "$CONFIG_FILE generate successfully"
    else
        echo "clang-format does not exist"
    fi
}

function mihomo-start() {
    mihomo_config_path="$HOME/.config/mihomo"
    if [ ! -f "$mihomo_config_path/Country.mmdb" ]; then
        echo "Error: Missing mmdb file"
        return
    fi

    if [ ! -d $mihomo_config_path/profile ]; then
        echo "Error: Missing profile file"
        return
    fi

    if [ "$1" == "-l" ]; then
        ls $mihomo_config_path/profile
        return
    fi

    if [ -z "$1" ]; then
        echo "Error: You need to specify the configuration file name"
        return
    fi

    if [ ! -f "$mihomo_config_path/profile/$1" ]; then
        echo "Error: $1 file does not exist"
        echo "  Use the -l parameter to view all configuration file names"
        return
    fi

    if type mihomo >/dev/null 2>&1; then
        mihomo -d $mihomo_config_path -f $mihomo_config_path/profile/$1
    else
        echo "Error: mihomo does not exist"
    fi
}
