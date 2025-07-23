#!/bin/bash

alias reload='source ~/.profile'
alias add-path='pwd >> ~/.cache/.path_bookmarks'
alias edit-path='vim ~/.cache/.path_bookmarks'
alias list="find . -maxdepth 1 -type d \( ! -name . \) -printf '%f\n'"
alias fname='find -maxdepth 1 -type f -iname'
alias git-init='source ~/.config/lese/git-init.sh'
alias lg='lazygit'
alias bear="bear -l $HOME/.local/lib/libear.so"
alias gsta='git status'
alias glog='git log --oneline --graph --color --all --decorate'
alias gbranch='git branch -vva'
alias g-tags='git ls-remote --tags'
alias g-branch='git log --graph --decorate --oneline --simplify-by-decoration --all'
alias gsub-clone='git clone --depth 1 --recurse-submodules --shallow-submodules'
alias gsub-init='git submodule update --init --recursive --depth 1'
alias git-count='git log --pretty=tformat: --numstat | gawk '"'"'{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "增加的行数:%s 删除的行数:%s 总行数: %s\n",add,subs,loc }'"'"''
alias slow='less --tabs=4 -RFX'
alias diff-better='diff-so-fancy | slow'

alias sshmv='ssh-keygen -R '
alias test-github='ssh -T git@github.com'
alias gen-key='ssh-keygen -m PEM -t rsa -b 4096 -C' # with comment
alias kill-gpg='gpgconf --kill all'
alias gen-gpg='gpg --full-generate-key'
alias get-gpg-id='gpg --list-secret-keys --keyid-format=long 2> /dev/null | grep "sec" | cut -d "/" -f 2 | cut -d " " -f 1'
alias get-gpg-key='gpg --armor --export `get-gpg-id`'

alias get-my-tool='git clone https://github.com/Lesords/My-Linux-Tool.git --depth=1'
alias get-my-vim='git clone https://github.com/Lesords/vim-config.git ~/.vim --depth 1 --recurse-submodules --shallow-submodules'

if [ -d "$HOME/.local/sbin" ]; then
    PATH="$HOME/.local/sbin:$PATH"
fi

export GPG_TTY=$(tty)

export LD_LIBRARY_PATH="$HOME/.local/lib"
