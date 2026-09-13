#!/usr/bin/env bash
# Shared helpers for tmux-auto-theme.

# get_tmux_option <name> <default>: global option value, or default if unset.
get_tmux_option() {
  local value
  value="$(tmux show-option -gqv "$1" 2>/dev/null)"
  if [ -n "$value" ]; then
    printf '%s' "$value"
  else
    printf '%s' "$2"
  fi
}

# ensure_update_environment <VAR>: append to update-environment unless listed.
ensure_update_environment() {
  tmux show-options -g update-environment 2>/dev/null | grep -q "[[:space:]]$1\$" && return 0
  tmux set-option -ga update-environment "$1"
}
