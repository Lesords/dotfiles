#!/bin/bash

vicd()
{
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

if type vifm >/dev/null 2>&1; then
    bind '"\eo": "\C-uvicd .\C-m"'
fi
