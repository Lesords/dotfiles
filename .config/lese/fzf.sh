#!/bin/bash

function rf() {
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
        echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
        echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header 'CTRL-T: Switch between ripgrep/fzf' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
}

function rfa() {
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case -. "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
}

fzf-cd() {
    local file="${1:-$HOME/.cache/.path_bookmarks}"
    [ ! -f "$file" ] && echo "路径文件不存在" && return 1

    local target=$(fzf --height 40% --preview 'ls -lAh {}' < "$file")
    cd "$target" 2>/dev/null || echo "无效路径: $target"
}

if type fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"

    alias fzf-vim="fzf --bind 'enter:become(vim {})'"
    alias fzf-start="fzf --bind 'enter:become(start {})'"
    if [ -t 1 ]; then
        bind '"\C-f": "\C-ufzf-vim\C-m"'
        bind '"\eh": "\C-ufzf-cd\C-m"'
        if [ "$MSYSTEM" ]; then
            bind '"\ei": "\C-ufzf-start\C-m"'
        fi
    fi
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
