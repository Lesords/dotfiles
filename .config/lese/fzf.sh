#!/bin/bash

function rf() {
    rm -f /tmp/rg-fzf-{r,f}
    local hf=/tmp/rg-fzf-hidden
    echo false > "$hf"
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --height 85% \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "ctrl-t:transform:
          if [[ ! \$FZF_PROMPT =~ 'rg:' ]]; then
            if [[ \$(<$hf) = true ]]; then
              echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case -. {q} || true)+change-prompt(rg:text(hidden)> )+disable-search+transform-query:echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r\"
            else
              echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case  {q} || true)+change-prompt(rg:text> )+disable-search+transform-query:echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r\"
            fi
          else
            echo \"unbind(change)+change-prompt(fzf:filter> )+enable-search+transform-query:echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-r\"
          fi" \
        --bind "ctrl-h:transform:
          if [[ \$(<$hf) = true ]]; then
            echo false > '$hf'
            echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case  {q} || true)+change-prompt(rg:text> )+change-header(CTRL-T: switch ripgrep/fzf | CTRL-H: toggle hidden | Ctrl-f: file picker)\"
          else
            echo true > '$hf'
            echo \"rebind(change)+reload(sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case -. {q} || true)+change-prompt(rg:text(hidden)> )+change-header(CTRL-T: switch ripgrep/fzf | CTRL-H: toggle hidden | Ctrl-f: file picker)\"
          fi" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt 'rg:text> ' \
        --delimiter : \
        --header 'CTRL-T: switch ripgrep/fzf | CTRL-H: toggle hidden | Ctrl-f: file picker' \
        --bind "ctrl-f:become(bash -c 'source \$HOME/.config/lese/fzf.sh 2>/dev/null && fzf-vim')" \
        --bind "ctrl-/:change-preview-window(down,60%,border,+{2}/3|right,50%,border,+{2}/3|hidden)" \
        --preview 'bat --color=always -p {1} --highlight-line {2}' \
        --preview-window 'down,60%,border,+{2}/3' \
        --bind 'enter:become(vim {1} +{2})'
}

fzf-cd() {
    local file="${1:-$HOME/.cache/.path_bookmarks}"
    [ ! -f "$file" ] && echo "路径文件不存在" && return 1

    local target=$(fzf --height 40% --preview 'ls -lAh {}' --preview-window hidden:wrap --bind 'ctrl-/:toggle-preview' < "$file")
    [ -z "$target" ] && echo "已取消" && return 0
    cd "$target" 2>/dev/null || echo "无效路径: $target"
}

# 常用命令存 ~/.cache/.cmd_bookmarks，一行一条
fzf-cmd() {
    local file="$HOME/.cache/.cmd_bookmarks"
    local hist=no prompt='cmd:book> ' expect=ctrl-a,ctrl-e,ctrl-d,ctrl-o
    local header='Enter: 填入命令行 | Ctrl-O: 执行 | Ctrl-A: 添加 | Ctrl-E: 编辑 | Ctrl-D: 删除 | Esc: 退出'
    case "${1:-}" in
        -h|history) hist=yes
            prompt='cmd:hist> '
            expect=ctrl-a,ctrl-s,ctrl-o
            header='Enter: 填入命令行 | Ctrl-O: 执行 | Ctrl-S: 收藏为常用 | Ctrl-A: 添加 | Esc: 退出'
            ;;
    esac
    local out out2 key2 pick= new tmp edited query key choice
    local -a hlines lines fields
    mapfile -t hlines < <(history | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' | tac | awk '$0 && !seen[$0]++')

    while :; do
        if [[ $hist == yes ]]; then
            lines=("${hlines[@]}")
        else
            mapfile -t lines < "$file" 2>/dev/null || lines=()
        fi
        out=$(printf '%s\n' "${lines[@]}" | FZF_DEFAULT_OPTS= FZF_DEFAULT_OPTS_FILE= \
            fzf --height 60% --layout=reverse --border \
                --prompt "$prompt" --header "$header" \
                --print-query --expect="$expect")
        mapfile -t fields <<<"$out"
        query=${fields[0]} key=${fields[1]} choice=${fields[2]}

        if [[ -z $key || $key == ctrl-o ]]; then
            [[ -n $choice ]] || return
            if [[ $key == ctrl-o ]]; then
                eval "$choice"
            elif [[ ${READLINE_LINE+set} ]]; then
                READLINE_LINE=$choice
                READLINE_POINT=${#READLINE_LINE}
            elif [[ -n $TMUX ]]; then
                stty -echo
                tmux set-buffer -b fzf-cmd -- "$choice"
                tmux paste-buffer -b fzf-cmd
                stty echo
            else
                eval "$choice"
            fi
            return
        fi
        [[ -n $choice || $key == ctrl-a ]] || continue

        case $key in
            ctrl-a)
                if ((${#hlines[@]})); then
                    out2=$(printf '%s\n' "${hlines[@]}" | FZF_DEFAULT_OPTS= FZF_DEFAULT_OPTS_FILE= \
                        fzf --height 40% --layout=reverse --border \
                            --prompt 'cmd:pick> ' --query="$query" --expect=ctrl-e \
                            --header 'Enter: 添加 | Ctrl-E: 选后编辑 | Esc: 手动输入')
                    key2=$(sed -n '1p' <<<"$out2")
                    pick=$(tail -n +2 <<<"$out2")
                    if [[ -z $key2 && -n $pick ]]; then
                        ! grep -qxF "$pick" "$file" 2>/dev/null && printf '%s\n' "$pick" >> "$file"
                        continue
                    fi
                    [[ $key2 == ctrl-e ]] || pick=
                fi
                read -e -r -p 'new cmd: ' -i "$pick" new
                [[ -n $new ]] && ! grep -qxF "$new" "$file" 2>/dev/null && printf '%s\n' "$new" >> "$file"
                ;;
            ctrl-e)
                tmp=$(mktemp /tmp/fzf-cmd.XXXXXX)
                printf '%s\n' "$choice" > "$tmp"
                "${EDITOR:-vim}" "$tmp"
                edited=$(grep -m1 '[^[:space:]]' "$tmp")
                rm -f "$tmp"
                [[ -n $edited && $edited != "$choice" ]] || continue
                OLD="$choice" NEW="$edited" \
                    awk '$0==ENVIRON["OLD"] && !d {$0=ENVIRON["NEW"]; d=1} $0 && !seen[$0]++' \
                    "$file" > "$file.tmp"
                mv "$file.tmp" "$file"
                ;;
            ctrl-d)
                { grep -vFx "$choice" "$file" || true; } > "$file.tmp"
                mv "$file.tmp" "$file"
                ;;
            ctrl-s)
                ! grep -qxF "$choice" "$file" 2>/dev/null \
                    && printf '%s\n' "$choice" >> "$file" && echo "已收藏: $choice"
                ;;
        esac
    done
}

fzf-vim() {
    local f=/tmp/fzf-vim-mode
    [[ -f $f ]] || echo vim > "$f"
    local mode=$(<$f)
    fzf \
        --height 70% \
        --bind "enter:transform:echo \"become(\$(<$f) {})\"" \
        --bind "ctrl-t:transform:
            if [[ \$(<$f) = nvim ]]; then
                echo vim > '$f'; echo 'change-prompt(vim:file> )'
            else
                echo nvim > '$f'; echo 'change-prompt(nvim:file> )'
            fi" \
        --bind "ctrl-f:become(bash -c 'source \$HOME/.config/lese/fzf.sh 2>/dev/null && rf')" \
        --prompt "${mode}:file> " \
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
                echo vim > '$f'; echo 'change-prompt(vim:file> )'
            else
                echo nvim > '$f'; echo 'change-prompt(nvim:file> )'
            fi" \
        --prompt "${mode}:file> " \
        --header 'CTRL-T: toggle vim/nvim | Enter: open'
}

# agents: "launcher:session根目录[:排除]" — 加 agent 加一行
ai-session() {
    local cur="${1:-}" a launcher root skip n mark choice
    local agents=(
        "claude-sessions:$HOME/.claude/projects:agent-*"
        "codex-sessions:$HOME/.codex/sessions:"
        "pi-sessions:$HOME/.pi/agent/sessions:"
    )
    local -a rows
    for a in "${agents[@]}"; do
        launcher=${a%%:*}
        root=${a#*:}
        skip=${root#*:}
        root=${root%%:*}
        command -v "$launcher" >/dev/null 2>&1 || continue
        n=$(find "$root" -name '*.jsonl' ${skip:+! -name "$skip"} 2>/dev/null | wc -l)
        (( n )) || continue
        [[ $launcher == "$cur" ]] && mark=$'\e[38;5;45m▸\e[0m ' || mark='  '
        rows+=("${mark}"$'\e[38;5;252m'"${launcher}"$'\e[0m'$'\t'$'\e[38;5;242m'"${n} sessions"$'\e[0m')
    done
    ((${#rows[@]})) || { echo "No session pickers available."; return; }
    choice=$(printf '%s\n' "${rows[@]}" | FZF_DEFAULT_OPTS= FZF_DEFAULT_OPTS_FILE= \
        fzf --ansi --exact --height=8 --no-sort --layout=reverse \
            --border=rounded '--border-label=" AI Session Pickers "' \
            --border-label-pos=2 \
            --color=border:#0ABDC6,label:#0ABDC6,header:#D300C4 \
            --color=bg+:#111133,fg+:#ffffff,hl+:#D300C4,hl:#0ABDC6 \
            --color=pointer:#D300C4,marker:#0ABDC6,spinner:#0ABDC6 \
            --delimiter='\t' --with-nth=1,2 --nth=1 \
            --prompt='❯ ' --pointer='▶' \
            --header=$'\e[2mEnter: open  Esc: quit\e[0m')
    [[ -n $choice ]] || return
    launcher=$(printf '%s' "$choice" | sed -e $'s/\x1b\\[[0-9;]*m//g' \
        -e 's/^[▸ ]*//' | cut -f1)
    command -v "$launcher" >/dev/null 2>&1 && "$launcher"
}

if type fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"

    alias fzf-start="fzf --bind 'enter:become(start {})'"
    if [ -t 1 ]; then
        bind -x '"\C-f": "fzf-vim"'
        bind -x '"\eg": "fzf-cmd"'
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
    --bind "ctrl-/:change-preview-window(right|down|hidden)"
    --bind "ctrl-e:preview-half-page-down"
    --bind "ctrl-y:preview-half-page-up"'

export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree -C {}'"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}' --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'"
