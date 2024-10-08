#!/bin/bash

user_config() {
    git config --global user.name $1
    git config --global user.email $2
}

core_config() {
    git config --global core.editor vim
    git config --global core.filemode false
    git config --global core.quotePath false
}

icdiff_config() {
    git config --global icdiff.options '--highlight --line-numbers'
}

http_config() {
    git config --global http.postBuffer    5000000
    git config --global http.lowSpeedLimit 0
    git config --global http.lowSpeedTime  999999
}

diffSF_config() {
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global interactive.diffFilter "diff-so-fancy --patch"
}

delta_config() {
    git config --global include.path "$HOME/.config/delta/.gitconfig"
    git config --global core.pager "delta"
    git config --global --unset interactive.diffFilter
}

gpg_config() {
    git config --global user.signingkey `get-gpg-id`
    git config --global commit.gpgsign true
}

main() {
    if [ $# -eq 2 ]; then
        user_config $1 $2
    fi

    core_config
    http_config

    icdiff_config
    diffSF_config

    if [ "`get-gpg-id`" ]; then
        gpg_config
    fi
}

if [[ $# -eq 1 && $1 == "--help" || $1 == "-h" ]]; then
    echo "Usage: git_init.sh [name] [email]" && exit 0
fi

if [ $# -eq 2 ]
then
    main $1 $2
else
    main
fi
