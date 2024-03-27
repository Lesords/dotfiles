#!/bin/bash

alias reload='source ~/.bashrc'
alias git-init='source ~/.config/lese/git-init.sh'
alias lg='lazygit'
alias gsta='git status'
alias git-count='git log --pretty=tformat: --numstat | gawk '"'"'{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "增加的行数:%s 删除的行数:%s 总行数: %s\n",add,subs,loc }'"'"''
alias slow='less --tabs=4 -RFX'
alias diff-better='diff-so-fancy | slow'

alias gen-key='ssh-keygen -m PEM -t rsa -b 4096 -C' # with comment
alias test-github='ssh -T git@github.com'
alias gen-gpg='gpg --full-generate-key'
alias get-gpg-id='gpg --list-secret-keys --keyid-format=long | grep "sec" | cut -d "/" -f 2 | cut -d " " -f 1'
alias get-gpg-key='gpg --armor --export `get-gpg-id`'

if [ -d "$HOME/.local/sbin" ]; then
    PATH="$HOME/.local/sbin:$PATH"
fi

export GPG_TTY=$(tty)
