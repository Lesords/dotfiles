#!/usr/bin/env bash

[ ! -f /tmp/i3_mode ] || echo "default" > /tmp/i3_mode

mode=$(cat /tmp/i3_mode)

if [ "$mode" = "resize" ]; then
    echo " 󰁌 RESIZE"
else
    echo ""
fi
