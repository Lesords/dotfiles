#!/bin/bash

wifi=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}')
eth=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="ethernet"{print $1; exit}')

if [[ -n "$wifi" ]] && ip link show $wifi | grep -q "state UP"; then
    echo "%{F#F0C674} "
elif [[ -n "$eth" ]] && ip link show $eth | grep -q "state UP"; then
    echo "%{F#F0C674} "
else
    echo "%{F#F0C674}󰖟 "
fi
