#!/bin/bash

# Checks if the script's stdout is connected to a terminal
if [ -t 1 ]; then
    if type tree >/dev/null 2>&1; then
        bind '";t": "\C-utree .\C-m"'
    fi
    if [[ "`uname -r | grep WSL`" || "$MSYSTEM" ]]; then
        bind '";o": "\C-uexplorer.exe .\C-m"'
    fi
    bind '";n": "\C-uclear -x\C-m"'
    bind '";u": "\C-udu -sh *\C-m"'
    bind '";l": "\C-ulsblk\C-m"'
    bind '";s": "\C-uls `la`\C-m"'
    bind '";mt": "\C-usudo mount"'
    bind '";mr": "\C-usudo umount"'
    bind '";j": "\C-utmux at -t "'
    bind '";f": "\C-ufind . -type f -name \""'
    bind '";g": "\C-ugit clone --depth 1 --recurse-submodules --shallow-submodules "'
fi
