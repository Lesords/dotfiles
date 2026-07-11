#!/bin/bash

get_state() {
    nmcli -t -f DEVICE,STATE device | awk -F: -v dev="$1" '$1==dev {print $2}'
}

get_ip() {
    nmcli -t -f IP4.ADDRESS device show "$1" 2>/dev/null | awk -F: '/IP4.ADDRESS/ {print $2}'
}

wifi=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}')
eth=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="ethernet"{print $1; exit}')

wifi_state=$(get_state "$wifi")
eth_state=$(get_state "$eth")

wifi_ip=$(get_ip "$wifi")
eth_ip=$(get_ip "$eth")

format_state() {
    case "$1" in
        connected) echo "🟢 connected" ;;
        disconnected) echo "🔴 disconnected" ;;
        *) echo "⚪ $1" ;;
    esac
}

rofi -e "Network Status

  WiFi ($wifi)
    Status : $(format_state "$wifi_state")
    IP     : ${wifi_ip:-none}

  Ethernet ($eth)
    Status : $(format_state "$eth_state")
    IP     : ${eth_ip:-none}
" -theme $HOME/.config/rofi/network.rasi
