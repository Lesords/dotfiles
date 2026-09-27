#!/usr/bin/env bash
# agent-status-hook — tmux after-set-option → instant polybar refresh;
# hash-guarded so option bursts fire only on real @pane_* changes

h=$(tmux list-panes -a -F '#{@pane_agent}|#{@pane_status}' 2>/dev/null | md5sum | cut -d' ' -f1)
[ "$h" = "$(cat /tmp/agent-status.hash 2>/dev/null)" ] && exit 0
echo "$h" > /tmp/agent-status.hash
command -v polybar-msg >/dev/null && polybar-msg action '#agent-status.hook.0' >/dev/null 2>&1
