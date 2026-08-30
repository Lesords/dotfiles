#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/utils.sh"

check_current_session() {
    current_session=$(tmux display-message -p '#{session_name}')
    if echo "$current_session" | grep -q "^floax-"; then
        return 0
    fi
    local expected="floax-${current_session}"
    if tmux has-session -t "$expected" 2>/dev/null; then
        local attached
        attached=$(tmux display -p -t "$expected" '#{session_attached}' 2>/dev/null)
        if [ -n "$attached" ] && [ "$attached" -gt 0 ] 2>/dev/null; then
            tmux menu \
                "pop current window" p "run \"$CURRENT_DIR/embed.sh pop\""
        else
            tmux display-message -d 3000 \
                "FloaX: open floax first with Ctrl+Alt+o"
        fi
    else
        tmux display-message -d 3000 \
            "FloaX: open floax first with Ctrl+Alt+o"
    fi
    exit 0
}

check_current_session
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux menu \
    "size down" - "run \"$CURRENT_DIR/zoom-options.sh in\"" \
    "size up" + "run \"$CURRENT_DIR/zoom-options.sh out\"" \
    "full screen" f "run \"$CURRENT_DIR/zoom-options.sh full\"" \
    "reset size" r "run \"$CURRENT_DIR/zoom-options.sh reset\"" \
    "embed in session" e "run \"$CURRENT_DIR/embed.sh embed\"" 
    # "move up" u "run \"$CURRENT_DIR/move.sh up\"" \
    # "move left" l "run \"$CURRENT_DIR/move.sh left\"" \
