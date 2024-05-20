#!/bin/bash

if [ -t 1 ]; then
    if type tree >/dev/null 2>&1; then
        bind '";t": "\C-utree .\C-m"'
    fi
    bind '";u": "\C-udu -sh *\C-m"'
    bind '";l": "\C-ulsblk\C-m"'
    bind '";s": "\C-uls `la`\C-m"'
    bind '";mt": "\C-usudo mount"'
    bind '";mr": "\C-usudo umount"'
    bind '";f": "\C-ufind . -type f -name \""'
    bind '";g": "\C-ugit clone --depth 1 --recurse-submodules --shallow-submodules "'
fi
