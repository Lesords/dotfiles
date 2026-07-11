#!/usr/bin/env bash

STATE_FILE="/tmp/i3_mode"

echo "default" > "$STATE_FILE"

while true; do
    i3-msg -t subscribe '[ "mode" ]' 2>/dev/null | \
    jq -r '.change' 2>/dev/null | \
    while read -r mode; do
        [ -n "$mode" ] && echo "$mode" > "$STATE_FILE"
    done

    sleep 1
done
