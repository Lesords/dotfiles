#!/usr/bin/env bash
# Remote palette on SSH sessions, clear overrides on local ones.
# Usage: apply-theme.sh [--all] [<session-id>]

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

# client_is_remote <pid>: attached client came over SSH (Linux /proc only).
client_is_remote() {
  tr '\0' '\n' < "/proc/$1/environ" 2>/dev/null | grep -q '^SSH_CONNECTION=.\+'
}

# session_env_is_remote <session-id>: creation-time signal, used when no
# client is attached (attach-time updates may not have landed yet either).
session_env_is_remote() {
  tmux show-environment -t "$1" SSH_CONNECTION 2>/dev/null | grep -q '^SSH_CONNECTION=.\+'
}

is_remote() { # <session-id>
  local sess="$1" pids pid readable=0
  pids="$(tmux list-clients -t "$sess" -F '#{client_pid}' 2>/dev/null)"
  if [ -n "$pids" ]; then
    for pid in $pids; do
      tr '\0' '\n' < "/proc/$pid/environ" 2>/dev/null | grep -q . || continue
      readable=1
      client_is_remote "$pid" && return 0
    done
    # Live viewers prove a stale SSH record wrong: scrub it so popups and
    # future sessions stop inheriting it. Skipped when no environ was
    # readable (e.g. non-Linux) to avoid acting on zero evidence.
    if [ "$readable" = 1 ]; then
      scrub_session_ssh "$sess"
      return 1
    fi
  fi
  session_env_is_remote "$sess"
}

# scrub_session_ssh <session-id>: drop stale SSH records from session env.
# Next attach re-adds them via update-environment if still true.
scrub_session_ssh() {
  tmux set-environment -t "$1" -u SSH_CONNECTION 2>/dev/null
  tmux set-environment -t "$1" -u SSH_CLIENT 2>/dev/null
  tmux set-environment -t "$1" -u SSH_TTY 2>/dev/null
}

apply_one() { # <session-id>
  [ -n "$1" ] || return 0
  if is_remote "$1"; then
    apply_remote "$1"
  else
    apply_local "$1"
  fi
}

apply_all() {
  tmux list-sessions -F '#{session_id}' 2>/dev/null | while IFS= read -r sess; do
    apply_one "$sess"
  done
}

if [ "$1" = "--all" ] || [ -z "$1" ]; then
  apply_all
else
  apply_one "$1"
fi
