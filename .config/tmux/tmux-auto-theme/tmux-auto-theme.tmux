#!/usr/bin/env bash
# tmux-auto-theme: purple on remote (SSH), blue on local, per session.
# Local plugin (not tpm-managed); kept outside plugins/ so `tpm clean` keeps it.
# Colours live in scripts/themes.sh, overridable via @auto_theme_* options.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/helpers.sh
. "$CURRENT_DIR/scripts/helpers.sh"
# shellcheck source=scripts/themes.sh
. "$CURRENT_DIR/scripts/themes.sh"

# SSH_CONNECTION ships in tmux defaults; the rest are belt and braces (idempotent).
ensure_update_environment "SSH_CONNECTION"
ensure_update_environment "SSH_CLIENT"
ensure_update_environment "SSH_TTY"

# Global = local palette; local sessions inherit it by unsetting overrides.
tmux set-option -g @background     "$(get_tmux_option '@auto_theme_local_bg'       "$SSH_THEME_LOCAL_BG")"
tmux set-option -g @background-alt "$(get_tmux_option '@auto_theme_local_bg_alt'   "$SSH_THEME_LOCAL_BG_ALT")"
tmux set-option -g @foreground     "$(get_tmux_option '@auto_theme_local_fg'       "$SSH_THEME_LOCAL_FG")"
tmux set-option -g @foreground-alt "$(get_tmux_option '@auto_theme_local_fg_alt'   "$SSH_THEME_LOCAL_FG_ALT")"
tmux set-option -g @active         "$(get_tmux_option '@auto_theme_local_active'   "$SSH_THEME_LOCAL_ACTIVE")"
tmux set-option -g @selected       "$(get_tmux_option '@auto_theme_local_selected' "$SSH_THEME_LOCAL_SELECTED")"

# status-style re-expands per session (status-fg/bg only take literal colours).
tmux set-option -g status-style 'fg=#{@foreground},bg=#{@background}'

# Re-apply on session-created/attach/switch. #{hook_session} expands at fire
# time; sh-level single quotes stop $session-id being eaten as $1/$2/... .
tmux set-hook -g session-created "run-shell \"$CURRENT_DIR/scripts/apply-theme.sh '#{hook_session}'\""
tmux set-hook -g client-attached "run-shell \"$CURRENT_DIR/scripts/apply-theme.sh '#{hook_session}'\""
tmux set-hook -g client-session-changed "run-shell \"$CURRENT_DIR/scripts/apply-theme.sh '#{hook_session}'\""

# Cover sessions that already exist (e.g. on `prefix R` reload).
tmux run-shell "$CURRENT_DIR/scripts/apply-theme.sh --all"
