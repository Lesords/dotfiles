#!/usr/bin/env bash

mode=$(cat /tmp/i3_mode)

if [ "$mode" = "resize" ]; then
    echo " 󰁌 RESIZE"
else
    echo ""
fi
