#!/bin/bash

# Checks if the script's stdout is connected to a terminal
if [ -t 1 ]; then
    if type tree >/dev/null 2>&1; then
        bind '";t": "\C-utree -L 2 -a .\C-m"'
    fi
    if [[ "`uname -r | grep WSL`" || "$MSYSTEM" ]]; then
        bind -x '";o": "explorer.exe ."'
    fi
    if [[ "`uname | grep -i Linux`" ]]; then
        if type dolphin >/dev/null 2>&1; then
            bind -x '";o": "dolphin ."'
        fi
    fi
    bind -x '";n": "clear -x"'
    bind '";u": "\C-udu -sh *\C-m"'
    bind '";l": "\C-ulsblk\C-m"'
    bind '";s": "\C-uls -A | while IFS= read -r line; do echo && (if [ -d \"$line\" ]; then echo \"$line\": && ls \"$line\"; else echo \"$line\"; fi); done\C-m"'
    bind '";mt": "\C-usudo mount"'
    bind '";mr": "\C-usudo umount"'
    bind '";j": "\C-utmux at -t "'
    bind '";f": "\C-ufind . -type f -name \""'
    bind '";g": "\C-ugit clone --depth 1 --recurse-submodules --shallow-submodules "'
fi
