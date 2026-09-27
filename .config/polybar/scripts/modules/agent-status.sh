#!/usr/bin/env bash
# agent-status — polybar module: agent counts by status, click opens agent-rofi
# (@pane_* from tmux-agent-sidebar; \u escapes — bar fonts have no emoji)

declare -A counts=()
while IFS='|' read -r pane agent status _; do
  counts[$status]=$(( ${counts[$status]:-0} + 1 ))
done < <(tmux list-panes -a -F '#{pane_id}|#{@pane_agent}|#{@pane_status}|#{window_name}' 2>/dev/null |
  awk -F'|' '$2 != ""')

declare -A icon=(
  [waiting]=$'\uf252'
  [running]=$'\uf0e7'
  [idle]=$'\uf186'
  [background]=$'\uf186'
)
declare -A color=(
  [waiting]=#E06C75
  [running]=#E5C07B
  [idle]=#5C6370
  [background]=#61AFEF
)

out=""
for status in waiting running idle background; do
  n=${counts[$status]:-0}
  (( n > 0 )) && out+="%{F${color[$status]}}${icon[$status]} ${n}%{F-} "
done

# empty output (no agents) → the module takes no space in the bar
[ -n "$out" ] && printf '%%{A1:/home/lese/.config/i3/scripts/agent-rofi:}%s%%{A}\n' "${out% }"
