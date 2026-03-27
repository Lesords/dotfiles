#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

PRIMARY=$(xrandr --query | awk '/ primary/ {print $1}')

for m in $(xrandr --query | awk '/ connected/ {print $1}'); do
    if [ "$m" = "$PRIMARY" ]; then
        MONITOR=$m polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
    else
        MONITOR=$m polybar secondary 2>&1 | tee -a /tmp/polybar2.log & disown
    fi
done

echo "Bars launched..."
