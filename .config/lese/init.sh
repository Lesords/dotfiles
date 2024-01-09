#!/bin/bash

if [ $# -lt 1 ]; then
    echo "error: argument missing" && exit 1
fi

if [ "$1" == "--config" ]; then
    echo "" >> $HOME/.bashrc
    echo "source \"\$HOME/.config/lese/init.sh\" --file" >> $HOME/.bashrc
    echo "bashrc init successful"

    echo -e "please enter your git username: \c" && read username
    echo -e "please enter your git email: \c" && read email

    if [ -z $username -a -z $email ]; then
        $HOME/.config/lese/git-init.sh && echo "git-init successful"
    else
        $HOME/.config/lese/git-init.sh $username $email && echo "git-init $username $email successful"
    fi
fi

if [ "$1" == "--file" ]; then
    source "$HOME/.config/lese/config.sh"
    source "$HOME/.config/lese/functions.sh"
    source "$HOME/.config/lese/shellPrompt.sh"
    source "$HOME/.config/lese/shell_automatic_cd.sh" # ranger
    source "$HOME/.config/lese/vifm_automatic_cd.sh"  # vifm
fi
