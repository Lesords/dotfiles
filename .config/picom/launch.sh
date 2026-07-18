#!/bin/bash

picom_bin=$(command -v picom)

if pgrep -u "$USER" -x picom &>/dev/null; then
    exit 0
fi

if strings "$picom_bin" 2>/dev/null | grep -q "animations"; then
    exec "$picom_bin" --config "$HOME/.config/picom/picom_animation.conf" -b
else
    exec "$picom_bin" --config "$HOME/.config/picom/picom.conf" -b
fi
