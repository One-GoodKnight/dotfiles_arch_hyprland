#!/bin/bash

ACTIVE=$(hyprctl activewindow -j)
ACTIVE_CLASS=$(echo "$ACTIVE" | jq -r '.class')
ACTIVE_PID=$(echo "$ACTIVE" | jq -r '.pid')

if [ "$ACTIVE_CLASS" = "kitty" ]; then
    SOCKET=$(ls /tmp/kitty-* 2>/dev/null | grep "$ACTIVE_PID")
    CWD=$(kitty @ --to unix:"$SOCKET" ls | jq -r '.[].tabs[] | select(.is_focused) | .windows[] | select(.is_focused) | .foreground_processes[-1].cwd')
    kitty --directory "$CWD" &
else
    kitty &
fi
