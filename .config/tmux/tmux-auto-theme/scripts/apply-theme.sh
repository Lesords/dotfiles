#!/usr/bin/env bash
# Remote palette on SSH sessions, clear overrides on local ones.
# Usage: apply-theme.sh [--all] [<session-id>]

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
. "$CURRENT_DIR/helpers.sh"
# shellcheck source=themes.sh
. "$CURRENT_DIR/themes.sh"

# Palette user options in order; every value line below follows this order.
PALETTE=(@background @background-alt @foreground @foreground-alt @active @selected)

# One list-sessions call carries the id plus the palette each session
# currently shows (session override, or the global palette if unset).
CUR_FMT='#{session_id}|#{@background}|#{@background-alt}|#{@foreground}|#{@foreground-alt}|#{@active}|#{@selected}'

# client_is_remote <pid>: attached client came over SSH (Linux /proc only).
client_is_remote() {
  tr '\0' '\n' < "/proc/$1/environ" 2>/dev/null | grep -q '^SSH_CONNECTION=.\+'
}

# session_env_is_remote <session-id>: creation-time signal, used when no
# client is attached (attach-time updates may not have landed yet either).
session_env_is_remote() {
  tmux show-environment -t "$1" SSH_CONNECTION 2>/dev/null | grep -q '^SSH_CONNECTION=.\+'
}

# is_nested_client <pid>: popup/nested clients (TMUX in environ) carry the
# server's environment, not the viewer's - no evidence for theme or scrub.
is_nested_client() {
  tr '\0' '\n' < "/proc/$1/environ" 2>/dev/null | grep -q '^TMUX='
}

is_remote() { # <session-id>
  local sess="$1" pids pid readable=0
  pids="$(tmux list-clients -t "$sess" -F '#{client_pid}' 2>/dev/null)"
  if [ -n "$pids" ]; then
    for pid in $pids; do
      tr '\0' '\n' < "/proc/$pid/environ" 2>/dev/null | grep -q . || continue
      is_nested_client "$pid" && continue
      readable=1
      client_is_remote "$pid" && return 0
    done
    # Live non-nested viewers prove a stale SSH record wrong: scrub it so
    # popups and future sessions stop inheriting it. Skipped when no environ
    # was readable (e.g. non-Linux) to avoid acting on zero evidence.
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
  tmux show-environment -t "$1" 2>/dev/null | grep -qE '^SSH_(CONNECTION|CLIENT|TTY)=' || return 0
  tmux set-environment -t "$1" -u SSH_CONNECTION 2>/dev/null
  tmux set-environment -t "$1" -u SSH_CLIENT 2>/dev/null
  tmux set-environment -t "$1" -u SSH_TTY 2>/dev/null
}

# read_targets: fill WANT_LINE (remote palette) and LOCAL_LINE (global
# palette) from one show-options -g call. Unset @auto_theme_remote_* fall
# back to the built-in defaults.
read_targets() {
  local -a w l
  w=("$SSH_THEME_REMOTE_BG" "$SSH_THEME_REMOTE_BG_ALT" "$SSH_THEME_REMOTE_FG" "$SSH_THEME_REMOTE_FG_ALT" "$SSH_THEME_REMOTE_ACTIVE" "$SSH_THEME_REMOTE_SELECTED")
  l=("" "" "" "" "" "")
  local name val
  while read -r name val; do
    val="${val%\"}"; val="${val#\"}"
    case "$name" in
      @auto_theme_remote_bg)       w[0]=$val ;;
      @auto_theme_remote_bg_alt)   w[1]=$val ;;
      @auto_theme_remote_fg)       w[2]=$val ;;
      @auto_theme_remote_fg_alt)   w[3]=$val ;;
      @auto_theme_remote_active)   w[4]=$val ;;
      @auto_theme_remote_selected) w[5]=$val ;;
      @background)       l[0]=$val ;;
      @background-alt)   l[1]=$val ;;
      @foreground)       l[2]=$val ;;
      @foreground-alt)   l[3]=$val ;;
      @active)           l[4]=$val ;;
      @selected)         l[5]=$val ;;
    esac
  done < <(tmux show-options -g 2>/dev/null)
  WANT_LINE="${w[0]}|${w[1]}|${w[2]}|${w[3]}|${w[4]}|${w[5]}"
  LOCAL_LINE="${l[0]}|${l[1]}|${l[2]}|${l[3]}|${l[4]}|${l[5]}"
}

apply_remote() { # <session-id> <cur-line>: write only differing items.
  local sess="$1" i rc=0
  local -a cur want
  IFS='|' read -ra cur <<<"$2"
  IFS='|' read -ra want <<<"$WANT_LINE"
  for i in "${!PALETTE[@]}"; do
    [ "${cur[$i]}" = "${want[$i]}" ] && continue
    tmux set-option -t "$sess" "${PALETTE[$i]}" "${want[$i]}" >/dev/null 2>&1 || rc=$?
  done
  return "$rc"
}

apply_local() { # <session-id> <cur-line>: unset only overridden items.
  local sess="$1" i rc=0
  local -a cur loc
  IFS='|' read -ra cur <<<"$2"
  IFS='|' read -ra loc <<<"$LOCAL_LINE"
  for i in "${!PALETTE[@]}"; do
    # Matching the global palette = nothing to clear. -q: pre-3.4 tmux
    # errors unsetting never-set user options.
    [ "${cur[$i]}" = "${loc[$i]}" ] && continue
    tmux set-option -uq -t "$sess" "${PALETTE[$i]}" >/dev/null 2>&1 || rc=$?
  done
  return "$rc"
}

apply_one() { # <session-id> <cur-line>
  local sess="$1" rc
  [ -n "$sess" ] || return 0
  if is_remote "$sess"; then
    apply_remote "$sess" "$2"; rc=$?
  else
    apply_local "$sess" "$2"; rc=$?
  fi
  # A session destroyed mid-apply has nothing left to theme - not an error.
  [ "$rc" -eq 0 ] || ! tmux has-session -t "$sess" 2>/dev/null
}

apply_all() {
  local fail=0 line sess cur
  while IFS= read -r line; do
    sess="${line%%|*}"
    cur="${line#*|}"
    apply_one "$sess" "$cur" || fail=1
  done < <(tmux list-sessions -F "$CUR_FMT" 2>/dev/null)
  return "$fail"
}

read_targets

if [ "$1" = "--all" ] || [ -z "$1" ]; then
  apply_all
else
  line="$(tmux display-message -p -t "$1" "$CUR_FMT" 2>/dev/null)"
  apply_one "$1" "${line#*|}"
fi
