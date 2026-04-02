#!/bin/bash

THEME=~/.config/rofi/powermenu-vertical.rasi

shutdown="󰐥 Shutdown"
reboot="󰜉 Reboot"
lock="󰌾 Lock"
suspend="󰤄 Suspend"
logout="󰍃 Logout"

confirm() {
    echo -e "Yes\nNo" | rofi -dmenu -p "  $1?" -theme "$THEME" \
        -me-select-entry "" -me-accept-entry "MousePrimary"
}

chosen=$(echo -e "$shutdown\n$reboot\n$lock\n$suspend\n$logout" \
    | rofi -dmenu -p "Power" -theme "$THEME" \
        -me-select-entry "" -me-accept-entry "MousePrimary")

case "$chosen" in
    "$shutdown")
        [ "$(confirm "Shutdown")" = "Yes" ] && systemctl poweroff ;;
    "$reboot")
        [ "$(confirm "Reboot")" = "Yes" ] && systemctl reboot ;;
    "$lock")
        i3lock ;;
    "$suspend")
        [ "$(confirm "Suspend")" = "Yes" ] && systemctl suspend ;;
    "$logout")
        [ "$(confirm "Logout")" = "Yes" ] && i3-msg exit ;;
esac
