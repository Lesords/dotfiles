#!/bin/bash

if type fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"

    alias fzf-vim="fzf --bind 'enter:become(vim {})'"
    if [ -t 1 ]; then bind '"\C-f": "\C-ufzf-vim\C-m"'; fi
fi

export FZF_DEFAULT_OPTS='
    --walker-skip .git,node_modules,target
    --height 60% --layout=reverse --border
    --preview "bat -n --color=always --line-range :500 {}"
    --bind "ctrl-/:change-preview-window(down|hidden|)"'

export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree -C {}'"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}' --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'"
