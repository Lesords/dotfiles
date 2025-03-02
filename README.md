# Introduction

This is my linux configuration

Here's what I have configured so far:

- [Vim configuration](https://github.com/Lesords/vim-config)
- tmux configuration and plugins
- lazygit configuration
- ranger configuration
- vifm configuration
- joshuto configuration
- btop configuration
- delta configuration
- Some useful bash files

# Installation

## Manual

Clone the repository with the following command

```bash
cd ~
git clone git@github.com:Lesords/dotfiles.git --depth 1 --recurse-submodules --shallow-submodules
```

Next, use the following command to move the configuration file to the user directory

```bash
cd dotfiles
./dot install
```

After the file move is complete, you can verify the configuration file using the following command

```bash
./dot status
./dot diff
```

Then, you can use the following command to bring the configuration file into effect

```bash
~/.config/lese/init.sh --config
```

Finally restart your terminal

## Git

Use the following command to automatically move all configuration files to the user directory

```bash
cd ~
git clone --bare git@github.com:Lesords/dotfiles.git --depth 1

git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME checkout

git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME submodule update --init --recursive --depth 1
```
