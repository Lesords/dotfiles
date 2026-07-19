#!/usr/bin/env bash
MY_MONITOR="$MONITOR"

i3-window-title | while read -r line; do
    if [ "$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .output')" = "$MY_MONITOR" ]; then
        echo "$line"
    else
        echo ""
    fi
done
