#!/bin/bash

if [ $# -lt 1 ]; then
    echo "ERROR: argument missing" \
        && echo "OPTION: " \
        && echo "  --config    initialization configuration file" \
        && exit 1
fi

if [ "$1" == "--config" ]; then
    CONFIG_FILE="$HOME/.profile"
    [ ! -f "$HOME/.profile" ] && CONFIG_FILE="$HOME/.bash_profile"

    is_init=`tail -3 "$CONFIG_FILE" | grep "config/lese/init.sh"`

    if [ "$is_init" ]; then
        echo "profile already initialized"
    else
        echo "" >> $CONFIG_FILE
        echo "source \"\$HOME/.config/lese/init.sh\" --file" >> $CONFIG_FILE
        echo "profile init successful"
    fi

    echo -e "Do you need to initialize git?(y/n) \c" && read option

    if [ "$option" == "n" ]; then
        exit 0
    fi

    echo -e "please enter your git username: \c" && read username
    echo -e "please enter your git email: \c" && read email

    if [ -z $username -a -z $email ]; then
        $HOME/.config/lese/git-init.sh && echo "git-init successful"
    else
        $HOME/.config/lese/git-init.sh $username $email && echo "git-init $username $email successful"
    fi
fi

if [ "$1" == "--file" ]; then
    source "$HOME/.config/lese/fzf.sh"
    source "$HOME/.config/lese/config.sh"
    source "$HOME/.config/lese/keymap.sh"
    source "$HOME/.config/lese/functions.sh"
    source "$HOME/.config/lese/shellPrompt.sh"
    source "$HOME/.config/lese/automatic_cd.sh"
fi
