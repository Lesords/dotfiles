#!/usr/bin/env bash
# Remote palette on SSH sessions, clear overrides on local ones.
# Usage: apply-theme.sh <session-id> | --all

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
. "$CURRENT_DIR/helpers.sh"
# shellcheck source=themes.sh
. "$CURRENT_DIR/themes.sh"

PALETTE_OPTS="@background @background-alt @foreground @foreground-alt @active @selected"

remote_value() { # <suffix> <default>
  get_tmux_option "@auto_theme_remote_$1" "$2"
}

apply_remote() { # <session-id>
  local sess="$1"
  tmux set-option -t "$sess" @background     "$(remote_value bg       "$SSH_THEME_REMOTE_BG")" >/dev/null 2>&1
  tmux set-option -t "$sess" @background-alt "$(remote_value bg_alt   "$SSH_THEME_REMOTE_BG_ALT")" >/dev/null 2>&1
  tmux set-option -t "$sess" @foreground     "$(remote_value fg       "$SSH_THEME_REMOTE_FG")" >/dev/null 2>&1
  tmux set-option -t "$sess" @foreground-alt "$(remote_value fg_alt   "$SSH_THEME_REMOTE_FG_ALT")" >/dev/null 2>&1
  tmux set-option -t "$sess" @active         "$(remote_value active   "$SSH_THEME_REMOTE_ACTIVE")" >/dev/null 2>&1
  tmux set-option -t "$sess" @selected       "$(remote_value selected "$SSH_THEME_REMOTE_SELECTED")" >/dev/null 2>&1
}

apply_local() { # <session-id>
  local sess="$1" opt
  for opt in $PALETTE_OPTS; do
    tmux set-option -u -t "$sess" "$opt" >/dev/null 2>&1
  done
}

apply_one() { # <session-id>
  local sess="$1" env
  [ -n "$sess" ] || return 0
  env="$(tmux show-environment -t "$sess" SSH_CONNECTION 2>/dev/null)" || return 0
  if printf '%s\n' "$env" | grep -q '^SSH_CONNECTION='; then
    apply_remote "$sess"
  else
    apply_local "$sess"
  fi
}

if [ "$1" = "--all" ]; then
  tmux list-sessions -F '#{session_id}' 2>/dev/null | while IFS= read -r sess; do
    apply_one "$sess"
  done
else
  apply_one "$1"
fi
