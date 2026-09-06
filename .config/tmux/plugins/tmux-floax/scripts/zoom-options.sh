#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

resize() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    current_width=$(tmux display -p '#{window_width}')
    current_height=$(tmux display -p '#{window_height}')
    if [ $((current_height+step)) -le 0 ] || [ $((current_width+step)) -le 0 ]; then
        return
    fi
    ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"
    if [ $((current_height+step)) -gt "$(tmux display -p -t "${ORIGIN_SESSION}:" '#{window_height}')" ] || 
        [ $((current_width+step)) -gt "$(tmux display -p -t "${ORIGIN_SESSION}:" '#{window_width}')" ]; then
        return
    fi
    tmux setenv -g FLOAX_WIDTH $((current_width+step))
    tmux setenv -g FLOAX_HEIGHT $((current_height+step))
    tmux detach-client
    tmux_popup
}

full_screen() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    tmux setenv -g FLOAX_WIDTH 100%
    tmux setenv -g FLOAX_HEIGHT 100%
    tmux detach-client
    tmux_popup
}

reset_size() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    tmux setenv -g FLOAX_WIDTH "$(tmux_option_or_fallback '@floax-width' '80%')" 
    tmux setenv -g FLOAX_HEIGHT "$(tmux_option_or_fallback '@floax-height' '80%')" 
    tmux detach-client
    tmux_popup
}

unlock_bindings() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    set_bindings
    local saved_title
    saved_title="$(tmux showenv -g FLOAX_TITLE_SAVED 2>/dev/null | cut -d '=' -f 2-)"
    if [ -n "$saved_title" ]; then
        change_popup_title "$saved_title"
        tmux setenv -gu FLOAX_TITLE_SAVED
    else
        change_popup_title "$DEFAULT_TITLE"
    fi
}

toggle_bindings() {
    if tmux list-keys -T root C-M-f >/dev/null 2>&1; then
        lock_bindings
    else
        unlock_bindings
    fi
}

lock_bindings() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    tmux unbind -n C-M-f
    tmux unbind -n C-M-r
    tmux unbind -n C-M-e
    tmux setenv -g FLOAX_TITLE_SAVED "$FLOAX_TITLE"
    change_popup_title "$LOCKED_TITLE"
}

change_popup_title() {
    cleanup_bindings_if_inactive || return 0
    require_origin_session || return 0
    tmux setenv -g FLOAX_TITLE "$1"
    tmux detach-client
    tmux_popup
}

case "$1" in
    in)
        step=-5
        resize
        ;;
    out)
        step=5
        resize
        ;;
    full)
        full_screen
        ;;
    reset)
        reset_size
        ;;
    lock)
        lock_bindings
        ;;
    unlock)
        unlock_bindings
        ;;
    toggle)
        toggle_bindings
        ;;
esac
