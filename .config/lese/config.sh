#!/bin/bash

alias reload='source ~/.bashrc'
alias git-init='source ~/.config/lese/git-init.sh'
alias lg='lazygit'
alias gsta='git status'
alias git-count='git log --pretty=tformat: --numstat | gawk '"'"'{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "增加的行数:%s 删除的行数:%s 总行数: %s\n",add,subs,loc }'"'"''
alias slow='less --tabs=4 -RFX'
alias diff-better='diff-so-fancy | slow'

if [ -d "$HOME/.local/sbin" ]; then
    PATH="$HOME/.local/sbin:$PATH"
fi

export GPG_TTY=$(tty)
