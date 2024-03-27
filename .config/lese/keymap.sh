#!/bin/bash

if type tree >/dev/null 2>&1; then
    bind '";t": "\C-utree .\C-m"'
fi
bind '";u": "\C-udu -sh *\C-m"'
