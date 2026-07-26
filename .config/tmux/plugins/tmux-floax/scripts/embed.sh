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

show_embed_menu() {
    local windows
    windows=$(tmux list-windows -t "$ORIGIN_SESSION" -F '#{window_index}:#{window_name}' 2>/dev/null)
    if [ -z "$windows" ]; then
        embed_as_new_window
        return
    fi

    local menu_args=("-T" "Embed into...")
    while IFS=':' read -r win_idx win_name; do
        local label="in $win_idx: $win_name"
        local cmd="run -b '${CURRENT_DIR}/embed.sh join-into $win_idx'"
        menu_args+=("$label" "" "$cmd")
    done <<< "$windows"

    menu_args+=("new window" "n" "run -b '${CURRENT_DIR}/embed.sh new-window'")
    tmux menu "${menu_args[@]}"
}

embed_as_new_window() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    unset_bindings
    number_of_windows=$(tmux list-windows -t "$FLOAX_SESSION_NAME" | wc -l)
    if [ "$number_of_windows" -eq 1 ]; then
        tmux neww -d
    fi
    tmux movew -t "${ORIGIN_SESSION}:"
    tmux detach-client
}

embed_into_window() {
    local target="$1"
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    unset_bindings
    tmux neww -d
    tmux join-pane -t "${ORIGIN_SESSION}:${target}"
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
        show_embed_menu
        ;;
    join-into)
        embed_into_window "$2"
        ;;
    new-window)
        embed_as_new_window
        ;;
    pop)
        pop
        ;;
esac
