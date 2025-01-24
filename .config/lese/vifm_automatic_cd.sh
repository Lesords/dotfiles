#!/bin/bash

vicd()
{
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    if [[ "$dst" =~ ^[[:space:]] ]]; then
        dst=$(echo "$dst" | sed 's/^[[:space:]]*//')
    fi
    cd "$dst" || echo "$dst"
}

if type vifm >/dev/null 2>&1; then
    if [ -t 1 ]; then bind '"\eo": "\C-uvicd .\C-m"'; fi
fi
