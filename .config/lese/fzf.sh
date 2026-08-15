#!/bin/bash

function rf() {
    rm -f /tmp/rg-fzf-{r,f}
    local hf=/tmp/rg-fzf-hidden
    echo false > "$hf"
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "ctrl-t:transform:
          if [[ ! \$FZF_PROMPT =~ ripgrep ]]; then
            if [[ \$(<$hf) = true ]]; then
              echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case -. {q} || true)+change-prompt(1. ripgrep(hidden)> )+disable-search+transform-query:echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r\"
            else
              echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case  {q} || true)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r\"
            fi
          else
            echo \"unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-r\"
          fi" \
        --bind "ctrl-h:transform:
          if [[ \$(<$hf) = true ]]; then
            echo false > '$hf'
            echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case  {q} || true)+change-prompt(1. ripgrep> )+change-header(CTRL-T: switch ripgrep/fzf | CTRL-H: toggle hidden | Ctrl-f: file picker)\"
          else
            echo true > '$hf'
            echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case -. {q} || true)+change-prompt(1. ripgrep(hidden)> )+change-header(CTRL-T: switch ripgrep/fzf | CTRL-H: toggle hidden | Ctrl-f: file picker)\"
          fi" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header 'CTRL-T: switch ripgrep/fzf | CTRL-H: toggle hidden | Ctrl-f: file picker' \
        --bind "ctrl-f:become(bash -c 'source \$HOME/.config/lese/fzf.sh 2>/dev/null && fzf-vim')" \
        --bind "ctrl-/:change-preview-window(right,50%,border,+{2}+3/3|down,60%,border,+{2}+3/3|hidden)" \
        --preview 'bat --color=always -p {1} --highlight-line {2}' \
        --preview-window 'up,60%,border,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
}

fzf-cd() {
    local file="${1:-$HOME/.cache/.path_bookmarks}"
    [ ! -f "$file" ] && echo "路径文件不存在" && return 1

    local target=$(fzf --height 40% --preview 'ls -lAh {}' --preview-window hidden:wrap --bind 'ctrl-/:toggle-preview' < "$file")
    cd "$target" 2>/dev/null || echo "无效路径: $target"
}

fzf-vim() {
    local f=/tmp/fzf-vim-mode
    [[ -f $f ]] || echo vim > "$f"
    local mode=$(<$f)
    fzf \
        --bind "enter:transform:echo \"become(\$(<$f) {})\"" \
        --bind "ctrl-t:transform:
            if [[ \$(<$f) = nvim ]]; then
                echo vim > '$f'; echo 'change-prompt(vim> )'
            else
                echo nvim > '$f'; echo 'change-prompt(nvim> )'
            fi" \
        --bind "ctrl-f:become(bash -c 'source \$HOME/.config/lese/fzf.sh 2>/dev/null && rf')" \
        --prompt "$mode> " \
        --preview-window hidden \
        --header 'CTRL-T: toggle vim/nvim | Ctrl-f: rg search | Ctrl-/: preview | Enter: open'
}

fd-vim() {
    local f=/tmp/fzf-vim-mode
    [[ -f $f ]] || echo vim > "$f"
    local mode=$(<$f)
    fd ${@:-.} | fzf \
        --preview 'bat -n --color=always {}' \
        --bind "enter:transform:echo \"become(\$(<$f) {})\"" \
        --bind "ctrl-t:transform:
            if [[ \$(<$f) = nvim ]]; then
                echo vim > '$f'; echo 'change-prompt(vim> )'
            else
                echo nvim > '$f'; echo 'change-prompt(nvim> )'
            fi" \
        --prompt "$mode> " \
        --header 'CTRL-T: toggle vim/nvim | Enter: open'
}

ai-session() {
    local tools=(
        "claude-sessions"
        "codex-sessions"
    )
    local choice=$(printf "%s\n" "${tools[@]}" | fzf --no-preview --prompt="AI session> " --height=6 --layout=reverse --border --cycle)
    [ -n "$choice" ] && "$choice"
}

if type fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"

    alias fzf-start="fzf --bind 'enter:become(start {})'"
    if [ -t 1 ]; then
        bind -x '"\C-f": "fzf-vim"'
        bind '"\eh": "\C-ufzf-cd\C-m"'
        if [ "$MSYSTEM" ]; then
            bind -x '"\es": "fzf-start"'
        else
            bind -x '"\es": "claude-sessions"'
        fi
    fi
fi

export FZF_DEFAULT_OPTS='
    --walker-skip .git,node_modules,target
    --height 60% --layout=reverse --border
    --preview "bat -n --color=always --line-range :500 {}"
    --bind "ctrl-/:change-preview-window(right|down|hidden)"'

export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree -C {}'"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}' --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'"
