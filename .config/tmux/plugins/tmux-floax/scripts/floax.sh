#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"
FLOAX_STATUS_BAR=$(envvar_value FLOAX_STATUS_BAR)

CURRENT_SESSION="$(tmux display -p '#{session_name}')"

# Check if currently inside a floax popup
if echo "$CURRENT_SESSION" | grep -q "^floax-"; then
    # Inside popup → close it
    unset_bindings

    if [ -z "$FLOAX_TITLE" ]; then
        FLOAX_TITLE="$DEFAULT_TITLE"
    fi

    tmux setenv -g FLOAX_TITLE "$FLOAX_TITLE"
    tmux detach-client
else
    # Opening floax from origin session
    ORIGIN_SESSION="$CURRENT_SESSION"
    FLOAX_SESSION_NAME="floax-${ORIGIN_SESSION}"
    tmux setenv -g FLOAX_SESSION_NAME "$FLOAX_SESSION_NAME"
    tmux setenv -g ORIGIN_SESSION "$ORIGIN_SESSION"
    set_bindings

    # Check if the session exists
    if tmux has-session -t "$FLOAX_SESSION_NAME" 2>/dev/null; then
        tmux_popup
    else
        # Create a new session and attach to it
        tmux new-session -d -c "$(tmux display-message -p '#{pane_current_path}')" -s "$FLOAX_SESSION_NAME"
        tmux set-option -t "$FLOAX_SESSION_NAME" status "${FLOAX_STATUS_BAR}"
        tmux_popup
    fi
fi
