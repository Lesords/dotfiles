#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

# Must set these BEFORE using them in functions
ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"
# Inside popup, the current session IS the floax session
FLOAX_SESSION_NAME="$(tmux display -p '#{session_name}')"
if [ -z "$FLOAX_SESSION_NAME" ]; then
    FLOAX_SESSION_NAME="$DEFAULT_SESSION_NAME"
fi

embed() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    unset_bindings
    number_of_windows=$(tmux list-windows -t "$FLOAX_SESSION_NAME" | wc -l)
    if [ "$number_of_windows" -eq 1 ]; then
        # there's only one window, need to create an alternative
        # before moving the current one to another session
        # otherwise the session dies and popping back won't work
        tmux neww -d
    fi
    tmux movew -t "${ORIGIN_SESSION}:"
    tmux detach-client
}

pop() {
    target_session="$(envvar_value FLOAX_SESSION_NAME)"
    if [ -z "$target_session" ] || [ "$target_session" = "scratch" ]; then
        tmux display-message -d 3000 "FloaX: no session to pop to"
        return 1
    fi

    tmux run-shell -b "
        tmux has-session -t '$target_session' 2>/dev/null ||
            tmux new-session -d -s '$target_session' 2>/dev/null
        tmux movew -t '$target_session' 2>/dev/null
        tmux popup -E 'tmux attach-session -t \"$target_session\"' 2>/dev/null
    "
}

action=$1
case "$action" in
    embed)
        embed
        ;;
    pop)
        pop
        ;;
esac
